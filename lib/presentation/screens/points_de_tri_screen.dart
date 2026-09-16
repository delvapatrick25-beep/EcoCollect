import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/recycling_point.dart';
import '../../presentation/providers/recycling_point_provider.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
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
                itemBuilder: (_, i) {
                  final point = items[i];
                  return RecyclingPointCard(
                    point: point,
                    onTap: () => _showDetails(context, point),
                  );
                },
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les points de tri : $e',
          onRetry: () => ref.invalidate(recyclingPointProvider),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, RecyclingPoint point) {
    DetailBottomSheet.show(
      context,
      title: point.nom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PointRow(
            icon: Icons.place_outlined,
            label: 'Adresse',
            value: point.adresse,
          ),
          _PointRow(
            icon: Icons.recycling_outlined,
            label: 'Types acceptés',
            value: point.typesAcceptes.join(', '),
          ),
          _PointRow(
            icon: Icons.location_on_outlined,
            label: 'Coordonnées',
            value: '${point.latitude.toStringAsFixed(4)}, '
                '${point.longitude.toStringAsFixed(4)}',
          ),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}