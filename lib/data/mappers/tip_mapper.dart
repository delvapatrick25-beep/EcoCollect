import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tip.dart';

class TipMapper {
  TipMapper._();

  static Map<String, Object?> toMap(Tip tip) {
    return <String, Object?>{
      'id': tip.id,
      'titre': tip.titre,
      'contenu': tip.contenu,
      'categorie': tip.categorie,
      'imageUrl': tip.imageUrl,
    };
  }

  static Tip fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Tip(
      id: data['id'] as String? ?? snapshot.id,
      titre: data['titre'] as String,
      contenu: data['contenu'] as String,
      categorie: data['categorie'] as String,
      imageUrl: data['imageUrl'] as String?,
    );
  }
}