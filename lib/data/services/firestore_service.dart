import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  CollectionReference<Map<String, dynamic>> collection(String path);

  Future<void> setDocument(String collectionPath, String id, Map<String, Object?> data);

  Future<void> addDocument(String collectionPath, Map<String, Object?> data);

  Future<void> deleteDocument(String collectionPath, String id);

  Future<void> updateDocument(String collectionPath, String id, Map<String, Object?> data);

  Future<int> countDocuments(String collectionPath);
}