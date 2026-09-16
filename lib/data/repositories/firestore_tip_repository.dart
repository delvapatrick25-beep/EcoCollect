import '../../core/constants/firestore_collections.dart';
import '../mappers/tip_mapper.dart';
import '../models/tip.dart';
import '../services/firestore_service.dart';
import 'tip_repository.dart';

class FirestoreTipRepository implements TipRepository {
  FirestoreTipRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<List<Tip>> listenAll() {
    return _firestoreService
        .collection(FirestoreCollections.tips)
        .orderBy('titre')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(TipMapper.fromMap).toList(),
        );
  }

  @override
  Future<Tip?> getById(String id) async {
    final snapshot = await _firestoreService
        .collection(FirestoreCollections.tips)
        .doc(id)
        .get();
    if (!snapshot.exists) return null;
    return TipMapper.fromMap(snapshot);
  }
}