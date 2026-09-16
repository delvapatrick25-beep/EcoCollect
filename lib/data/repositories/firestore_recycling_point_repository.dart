import '../../core/constants/firestore_collections.dart';
import '../mappers/recycling_point_mapper.dart';
import '../models/recycling_point.dart';
import '../services/firestore_service.dart';
import 'recycling_point_repository.dart';

class FirestoreRecyclingPointRepository implements RecyclingPointRepository {
  FirestoreRecyclingPointRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<List<RecyclingPoint>> listenAll() {
    return _firestoreService
        .collection(FirestoreCollections.recyclingPoints)
        .orderBy('nom')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RecyclingPointMapper.fromMap)
              .toList(),
        );
  }

  @override
  Future<RecyclingPoint?> getById(String id) async {
    final snapshot = await _firestoreService
        .collection(FirestoreCollections.recyclingPoints)
        .doc(id)
        .get();
    if (!snapshot.exists) return null;
    return RecyclingPointMapper.fromMap(snapshot);
  }
}