import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_account.dart';
import 'auth_provider.dart';
import 'service_providers.dart';

/// Profil Firestore de l'utilisateur connecté (null si non connecté).
final userProvider = StreamProvider<UserAccount?>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return const Stream<UserAccount?>.empty();
  return ref.watch(userRepositoryProvider).listen(uid);
});