import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<UserCredential> signIn(String email, String password);

  Future<UserCredential> signUp(String email, String password);

  Future<void> signOut();
}