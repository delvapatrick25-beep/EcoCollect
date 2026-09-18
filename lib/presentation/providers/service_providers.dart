import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firestore_report_repository.dart';
import '../../data/repositories/firestore_user_repository.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/cloud_firestore_service.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/geocoding_service_impl.dart';
import '../../data/services/geolocator_location_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/geocoding_service.dart';
import '../../domain/services/location_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return CloudFirestoreService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingServiceImpl();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirestoreUserRepository(ref.watch(firestoreServiceProvider));
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return FirestoreReportRepository(ref.watch(firestoreServiceProvider));
});