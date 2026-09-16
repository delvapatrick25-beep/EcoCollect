import '../models/user_account.dart';

abstract class UserRepository {
  Stream<UserAccount?> listen(String uid);

  Future<UserAccount?> getById(String uid);

  Future<void> save(UserAccount user);

  Future<void> delete(String uid);
}