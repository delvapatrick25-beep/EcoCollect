import '../models/collection.dart';

abstract class CollectionRepository {
  Stream<List<Collection>> listenAll();

  Future<Collection?> getById(String id);
}