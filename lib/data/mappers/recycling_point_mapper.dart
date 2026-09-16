import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recycling_point.dart';

class RecyclingPointMapper {
  RecyclingPointMapper._();

  static Map<String, Object?> toMap(RecyclingPoint point) {
    return <String, Object?>{
      'id': point.id,
      'nom': point.nom,
      'adresse': point.adresse,
      'latitude': point.latitude,
      'longitude': point.longitude,
      'typesAcceptes': point.typesAcceptes,
    };
  }

  static RecyclingPoint fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return RecyclingPoint(
      id: data['id'] as String? ?? snapshot.id,
      nom: data['nom'] as String,
      adresse: data['adresse'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      typesAcceptes: List<String>.from(data['typesAcceptes'] as List<dynamic>? ?? []),
    );
  }
}