import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/collection_provider.dart';
import '../../presentation/widgets/collection_card.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(collectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Collectes')),
      body: async.when(
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'Aucune collecte à venir')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => CollectionCard(collection: items[i]),
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les collectes : $e',
          onRetry: () => ref.invalidate(collectionProvider),
        ),
      ),
    );
  }
}