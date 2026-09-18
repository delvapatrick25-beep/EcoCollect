import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tip.dart';
import '../../presentation/providers/tip_provider.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/tip_card.dart';

class ConseilsScreen extends ConsumerStatefulWidget {
  const ConseilsScreen({super.key});

  @override
  ConsumerState<ConseilsScreen> createState() => _ConseilsScreenState();
}

class _ConseilsScreenState extends ConsumerState<ConseilsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tipProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conseils',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: async.when(
        data: (items) {
          final filteredItems = items.where((tip) {
            return tip.titre.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un conseil...',
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
                    ? const EmptyState(message: 'Aucun conseil trouvé')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        itemCount: filteredItems.length,
                        itemBuilder: (_, i) {
                          final tip = filteredItems[i];
                          return TipCard(
                            tip: tip,
                            onTap: () => _showDetails(context, tip),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les conseils : $e',
          onRetry: () => ref.invalidate(tipProvider),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Tip tip) {
    final colorScheme = Theme.of(context).colorScheme;

    DetailBottomSheet.show(
      context,
      title: tip.titre,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tip.categorie,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tip.contenu,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}