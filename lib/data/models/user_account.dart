class UserAccount {
  final String uid;
  final String email;
  final String pseudo;
  final DateTime createdAt;

  const UserAccount({
    required this.uid,
    required this.email,
    required this.pseudo,
    required this.createdAt,
  });

  UserAccount copyWith({
    String? uid,
    String? email,
    String? pseudo,
    DateTime? createdAt,
  }) {
    return UserAccount(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      pseudo: pseudo ?? this.pseudo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}