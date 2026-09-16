import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/recycling_point.dart';
import '../../data/repositories/firestore_recycling_point_repository.dart';
import 'service_providers.dart';

final recyclingPointRepositoryProvider = Provider(
  (ref) => FirestoreRecyclingPointRepository(
    ref.watch(firestoreServiceProvider),
  ),
);

final recyclingPointProvider = StreamProvider<List<RecyclingPoint>>((ref) {
  return ref.watch(recyclingPointRepositoryProvider).listenAll();
});