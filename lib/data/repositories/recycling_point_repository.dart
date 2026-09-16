import '../models/recycling_point.dart';

abstract class RecyclingPointRepository {
  Stream<List<RecyclingPoint>> listenAll();

  Future<RecyclingPoint?> getById(String id);
}