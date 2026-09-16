import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/tip.dart';
import '../../presentation/providers/tip_provider.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
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
                itemBuilder: (_, i) {
                  final tip = items[i];
                  return TipCard(
                    tip: tip,
                    onTap: () => _showDetails(context, tip),
                  );
                },
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les conseils : $e',
          onRetry: () => ref.invalidate(tipProvider),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Tip tip) {
    DetailBottomSheet.show(
      context,
      title: tip.titre,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tip.categorie,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tip.contenu,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}