import 'package:flutter/material.dart';

import '../../core/utils/app_date_utils.dart';
import '../../data/models/collection.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.collection,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.delete_outline),
        title: Text(collection.typeDechet),
        subtitle: Text(
          '${AppDateUtils.formatDate(collection.date)} '
          '${collection.heure} — ${collection.zone}',
        ),
        onTap: onTap,
      ),
    );
  }
}