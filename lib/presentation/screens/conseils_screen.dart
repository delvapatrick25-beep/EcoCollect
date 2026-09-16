import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/tip_provider.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/tip_card.dart';

class ConseilsScreen extends ConsumerWidget {
  const ConseilsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tipProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conseils')),
      body: async.when(
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'Aucun conseil disponible')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => TipCard(tip: items[i]),
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les conseils : $e',
          onRetry: () => ref.invalidate(tipProvider),
        ),
      ),
    );
  }
}