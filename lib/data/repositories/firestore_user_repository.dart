import '../../core/constants/firestore_collections.dart';
import '../mappers/user_account_mapper.dart';
import '../models/user_account.dart';
import '../services/firestore_service.dart';
import 'user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<UserAccount?> listen(String uid) {
    return _firestoreService
        .collection(FirestoreCollections.users)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      return UserAccountMapper.fromMap(snapshot);
    });
  }

  @override
  Future<UserAccount?> getById(String uid) async {
    final snapshot = await _firestoreService
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();
    if (!snapshot.exists) return null;
    return UserAccountMapper.fromMap(snapshot);
  }

  @override
  Future<void> save(UserAccount user) {
    return _firestoreService.setDocument(
      FirestoreCollections.users,
      user.uid,
      UserAccountMapper.toMap(user),
    );
  }

  @override
  Future<void> delete(String uid) {
    return _firestoreService.deleteDocument(FirestoreCollections.users, uid);
  }
}