import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/collection.dart';
import '../../data/repositories/firestore_collection_repository.dart';
import 'service_providers.dart';

final collectionRepositoryProvider = Provider(
  (ref) => FirestoreCollectionRepository(
    ref.watch(firestoreServiceProvider),
  ),
);

final collectionProvider = StreamProvider<List<Collection>>((ref) {
  return ref.watch(collectionRepositoryProvider).listenAll();
});

/// Prochaine collecte à venir (date la plus proche, >= aujourd'hui).
final nextCollectionProvider = StreamProvider<Collection?>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return ref
      .watch(collectionRepositoryProvider)
      .listenAll()
      .map((collections) {
        final upcoming = collections
            .where((c) => c.date.isAtSameMomentAs(today) || c.date.isAfter(today))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        return upcoming.isEmpty ? null : upcoming.first;
      });
});