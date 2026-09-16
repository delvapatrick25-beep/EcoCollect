import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_service.dart';

class CloudFirestoreService implements FirestoreService {
  CloudFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  @override
  Future<void> setDocument(
    String collectionPath,
    String id,
    Map<String, Object?> data,
  ) {
    return collection(collectionPath).doc(id).set(data);
  }

  @override
  Future<void> addDocument(String collectionPath, Map<String, Object?> data) async {
    await collection(collectionPath).add(data);
  }

  @override
  Future<void> deleteDocument(String collectionPath, String id) {
    return collection(collectionPath).doc(id).delete();
  }

  @override
  Future<void> updateDocument(
    String collectionPath,
    String id,
    Map<String, Object?> data,
  ) {
    return collection(collectionPath).doc(id).update(data);
  }

  @override
  Future<int> countDocuments(String collectionPath) async {
    final snapshot = await collection(collectionPath).count().get();
    return snapshot.count ?? 0;
  }
}