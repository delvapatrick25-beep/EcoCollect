import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/recycling_point_provider.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/recycling_point_card.dart';

class PointsDeTriScreen extends ConsumerWidget {
  const PointsDeTriScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recyclingPointProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Points de tri')),
      body: async.when(
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'Aucun point de tri')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) =>
                    RecyclingPointCard(point: items[i]),
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les points de tri : $e',
          onRetry: () => ref.invalidate(recyclingPointProvider),
        ),
      ),
    );
  }
}