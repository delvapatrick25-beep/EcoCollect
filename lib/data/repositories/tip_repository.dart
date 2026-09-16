import '../models/tip.dart';

abstract class TipRepository {
  Stream<List<Tip>> listenAll();

  Future<Tip?> getById(String id);
}