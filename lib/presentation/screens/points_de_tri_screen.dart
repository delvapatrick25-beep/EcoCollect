import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/recycling_point.dart';
import '../../presentation/providers/recycling_point_provider.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/recycling_point_card.dart';

class PointsDeTriScreen extends ConsumerStatefulWidget {
  const PointsDeTriScreen({super.key});

  @override
  ConsumerState<PointsDeTriScreen> createState() => _PointsDeTriScreenState();
}

class _PointsDeTriScreenState extends ConsumerState<PointsDeTriScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(recyclingPointProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Points de tri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: async.when(
        data: (items) {
          final filteredItems = items.where((point) {
            return point.nom.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un point de tri...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? const EmptyState(message: 'Aucun point de tri trouvé')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        itemCount: filteredItems.length,
                        itemBuilder: (_, i) {
                          final point = filteredItems[i];
                          return RecyclingPointCard(
                            point: point,
                            onTap: () => _showDetails(context, point),
                          );
                        },
                      ),
              ),
            ],
          );
        },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface,
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
