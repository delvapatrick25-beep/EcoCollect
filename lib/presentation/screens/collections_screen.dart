import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/collection.dart';
import '../../presentation/providers/collection_provider.dart';
import '../../presentation/widgets/collection_card.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  String? _selectedZone;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(collectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Collectes')),
      body: async.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(message: 'Aucune collecte à venir');
          }

          final zones = items.map((c) => c.zone).toSet().toList()..sort();
          final visible = _selectedZone == null
              ? items
              : items.where((c) => c.zone == _selectedZone).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildZoneFilter(zones),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(
                        message: 'Aucune collecte pour cette zone',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: visible.length,
                        itemBuilder: (_, i) {
                          final collection = visible[i];
                          return CollectionCard(
                            collection: collection,
                            onTap: () => _showDetails(collection),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les collectes : $e',
          onRetry: () => ref.invalidate(collectionProvider),
        ),
      ),
    );
  }

  Widget _buildZoneFilter(List<String> zones) {
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Toutes'),
              selected: _selectedZone == null,
              onSelected: (_) => setState(() => _selectedZone = null),
            ),
          ),
          for (final zone in zones)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(zone),
                selected: _selectedZone == zone,
                onSelected: (_) => setState(() => _selectedZone = zone),
              ),
            ),
        ],
      ),
    );
  }

  void _showDetails(Collection collection) {
    DetailBottomSheet.show(
      context,
      title: collection.typeDechet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: 'Zone',
            value: collection.zone,
          ),
          _InfoRow(
            label: 'Date',
            value: AppDateUtils.formatLongDate(collection.date),
          ),
          _InfoRow(
            label: 'Heure',
            value: collection.heure,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}