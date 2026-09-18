import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tip.dart';
import '../../data/repositories/firestore_tip_repository.dart';
import 'service_providers.dart';

final tipRepositoryProvider = Provider(
  (ref) => FirestoreTipRepository(
    ref.watch(firestoreServiceProvider),
  ),
);

final tipProvider = StreamProvider<List<Tip>>((ref) {
  return ref.watch(tipRepositoryProvider).listenAll();
});

final tipOfTheDayProvider = Provider<AsyncValue<Tip?>>((ref) {
  final tipsAsync = ref.watch(tipProvider);
  return tipsAsync.whenData((tips) {
    if (tips.isEmpty) return null;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  });
});
