import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_account.dart';

class UserAccountMapper {
  UserAccountMapper._();

  static Map<String, Object?> toMap(UserAccount user) {
    return <String, Object?>{
      'uid': user.uid,
      'email': user.email,
      'pseudo': user.pseudo,
      'createdAt': Timestamp.fromDate(user.createdAt),
    };
  }

  static UserAccount fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return UserAccount(
      uid: data['uid'] as String? ?? snapshot.id,
      email: data['email'] as String,
      pseudo: data['pseudo'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}