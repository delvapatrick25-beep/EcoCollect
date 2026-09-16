import 'package:flutter/material.dart';

class NouveauSignalementScreen extends StatelessWidget {
  const NouveauSignalementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau signalement')),
      body: const Center(
        child: Text('E07 — Formulaire de signalement (en construction)'),
      ),
    );
  }
}