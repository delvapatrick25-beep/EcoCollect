import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/collection.dart';

class CollectionMapper {
  CollectionMapper._();

  static Map<String, Object?> toMap(Collection collection) {
    return <String, Object?>{
      'id': collection.id,
      'date': Timestamp.fromDate(collection.date),
      'heure': collection.heure,
      'zone': collection.zone,
      'typeDechet': collection.typeDechet,
    };
  }

  static Collection fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Collection(
      id: data['id'] as String? ?? snapshot.id,
      date: (data['date'] as Timestamp).toDate(),
      heure: data['heure'] as String,
      zone: data['zone'] as String,
      typeDechet: data['typeDechet'] as String,
    );
  }
}