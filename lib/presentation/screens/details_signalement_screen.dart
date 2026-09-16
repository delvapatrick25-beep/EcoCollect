import 'package:flutter/material.dart';

class DetailsSignalementScreen extends StatelessWidget {
  final String? reportId;

  const DetailsSignalementScreen({super.key, this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du signalement')),
      body: Center(
        child: Text('E09 — Signalement $reportId (en construction)'),
      ),
    );
  }
}