import 'dart:async';
import 'dart:typed_data';

import 'package:ecocollect/data/models/report.dart';
import 'package:ecocollect/data/models/user_account.dart';
import 'package:ecocollect/data/repositories/report_repository.dart';
import 'package:ecocollect/data/repositories/user_repository.dart';
import 'package:ecocollect/domain/services/auth_service.dart';
import 'package:ecocollect/domain/services/geocoding_service.dart';
import 'package:ecocollect/domain/services/location_service.dart';
import 'package:ecocollect/presentation/providers/service_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

/// User Firebase simulé (mocktail). Stuber `.uid` avant utilisation.
class MockFirebaseUser extends Mock implements User {}

/// UserCredential Firebase simulé (mocktail). Stuber `.user`.
class MockFirebaseUserCredential extends Mock implements UserCredential {}

/// Fake AuthService : simule une session complète.
///
/// - `user` : session déjà ouverte (currentUser non-null dès le départ).
/// - `loginUser` : utilisateur « connecté » par `signIn`/`signUp` (parcours).
///
/// Tant que `loginUser` est `null`, signIn/signUp lèvent `UnimplementedError`
/// pour éviter un false-positive « succès » dans les tests d'erreur.
class FakeAuthService implements AuthService {
  final User? _sessionUser;
  final User? _loginUser;
  final Object? _signInError;
  final Object? _signUpError;

  bool _loggedIn = false;

  FakeAuthService({
    User? user,
    User? loginUser,
    Object? signInError,
    Object? signUpError,
  })  : _sessionUser = user,
        _loginUser = loginUser,
        _signInError = signInError,
        _signUpError = signUpError;

  @override
  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  @override
  User? get currentUser => _currentUser;

  User? get _currentUser => _loggedIn ? _loginUser : _sessionUser;

  @override
  Future<UserCredential> signIn(String email, String password) async {
    if (_signInError != null) throw _signInError;
    if (_loginUser == null) throw UnimplementedError();
    _loggedIn = true;
    return _credential();
  }

  @override
  Future<UserCredential> signUp(String email, String password) async {
    if (_signUpError != null) throw _signUpError;
    if (_loginUser == null) throw UnimplementedError();
    _loggedIn = true;
    return _credential();
  }

  @override
  Future<void> signOut() async {
    _loggedIn = false;
  }

  /// Credential mocké : `.user` pointe vers l'utilisateur connecté.
  UserCredential _credential() {
    final credential = MockFirebaseUserCredential();
    when(() => credential.user).thenReturn(_currentUser);
    return credential;
  }
}

/// Fake UserRepository en mémoire.
class FakeUserRepository implements UserRepository {
  final Map<String, UserAccount> _users = {};
  final StreamController<UserAccount?> _controller =
      StreamController<UserAccount?>.broadcast();

  void setUser(UserAccount user) {
    _users[user.uid] = user;
    _controller.add(user);
  }

  @override
  Stream<UserAccount?> listen(String uid) async* {
    yield _users[uid];
    yield* _controller.stream.where((u) => u?.uid == uid);
  }

  @override
  Future<UserAccount?> getById(String uid) async => _users[uid];

  @override
  Future<void> save(UserAccount user) async => setUser(user);

  @override
  Future<void> delete(String uid) async {
    _users.remove(uid);
    _controller.add(null);
  }
}

/// Fake ReportRepository en mémoire (stream temps réel).
class FakeReportRepository implements ReportRepository {
  final StreamController<List<Report>> _controller =
      StreamController<List<Report>>.broadcast();
  final List<Report> _reports = [];
  int _nextId = 1;

  void seed(List<Report> reports) {
    _reports.addAll(reports);
    _controller.add(List.unmodifiable(_reports));
  }

  @override
  Stream<List<Report>> listenMine(String userId) async* {
    yield List.of(_reports.where((r) => r.userId == userId));
    yield* _controller.stream.map(
      (all) => all.where((r) => r.userId == userId).toList(),
    );
  }

  @override
  Future<String> addReport({
    required String userId,
    required ReportType type,
    required String description,
    double? latitude,
    double? longitude,
    Uint8List? photoBytes,
  }) async {
    final report = Report(
      id: 'r${_nextId++}',
      userId: userId,
      type: type,
      description: description,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now(),
    );
    _reports.add(report);
    _controller.add(List.unmodifiable(_reports));
    return report.id;
  }

  @override
  Future<void> deleteReport(Report report) async {
    _reports.removeWhere((r) => r.id == report.id);
    _controller.add(List.unmodifiable(_reports));
  }
}

/// Fake LocationService : retourne [position] (null = non disponible).
class FakeLocationService implements LocationService {
  final Position? _position;

  FakeLocationService([this._position]);

  @override
  Future<Position?> getCurrentPosition() async => _position;
}

/// Fake GeocodingService : retourne une adresse fixe (ou null).
class FakeGeocodingService implements GeocodingService {
  final String? _address;

  FakeGeocodingService([this._address]);

  @override
  Future<String?> getAddress(double latitude, double longitude) async =>
      _address;
}

/// Kit complet d'overrides Riverpod : assemble tous les fakes.
class FakeEnv {
  final FakeAuthService auth;
  final FakeUserRepository userRepository;
  final FakeReportRepository reportRepository;
  final FakeLocationService location;
  final FakeGeocodingService geocoding;

  FakeEnv({
    FakeAuthService? auth,
    FakeUserRepository? userRepository,
    FakeReportRepository? reportRepository,
    FakeLocationService? location,
    FakeGeocodingService? geocoding,
  })  : auth = auth ?? FakeAuthService(),
        userRepository = userRepository ?? FakeUserRepository(),
        reportRepository = reportRepository ?? FakeReportRepository(),
        location = location ?? FakeLocationService(),
        geocoding = geocoding ?? FakeGeocodingService();

  Widget wrap(Widget child, {List<Override> extra = const []}) {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(auth),
        userRepositoryProvider.overrideWithValue(userRepository),
        reportRepositoryProvider.overrideWithValue(reportRepository),
        locationServiceProvider.overrideWithValue(location),
        geocodingServiceProvider.overrideWithValue(geocoding),
        ...extra,
      ],
      child: child,
    );
  }
}