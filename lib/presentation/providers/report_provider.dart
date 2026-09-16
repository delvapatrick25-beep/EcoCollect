import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/report.dart';
import 'auth_provider.dart';
import 'service_providers.dart';

final reportProvider = StreamProvider<List<Report>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return const Stream<List<Report>>.empty();
  return ref.watch(reportRepositoryProvider).listenMine(uid);
});