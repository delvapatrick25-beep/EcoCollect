import '../../core/constants/firestore_collections.dart';
import '../mappers/collection_mapper.dart';
import '../models/collection.dart';
import '../services/firestore_service.dart';
import 'collection_repository.dart';

class FirestoreCollectionRepository implements CollectionRepository {
  FirestoreCollectionRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<List<Collection>> listenAll() {
    return _firestoreService
        .collection(FirestoreCollections.collections)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(CollectionMapper.fromMap)
              .toList(),
        );
  }

  @override
  Future<Collection?> getById(String id) async {
    final snapshot = await _firestoreService
        .collection(FirestoreCollections.collections)
        .doc(id)
        .get();
    if (!snapshot.exists) return null;
    return CollectionMapper.fromMap(snapshot);
  }
}