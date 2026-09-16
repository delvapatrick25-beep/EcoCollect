import 'package:flutter/material.dart';

import '../../data/models/recycling_point.dart';

class RecyclingPointCard extends StatelessWidget {
  final RecyclingPoint point;
  final VoidCallback? onTap;

  const RecyclingPointCard({
    super.key,
    required this.point,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(point.nom),
        subtitle: Text(
          '${point.adresse}\n${point.typesAcceptes.join(' · ')}',
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}