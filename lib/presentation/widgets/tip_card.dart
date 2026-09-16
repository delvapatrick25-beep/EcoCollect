import 'package:flutter/material.dart';

import '../../data/models/tip.dart';

class TipCard extends StatelessWidget {
  final Tip tip;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.tip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.lightbulb_outline),
        title: Text(tip.titre),
        subtitle: Text('${tip.categorie} — ${tip.contenu}'),
        onTap: onTap,
      ),
    );
  }
}