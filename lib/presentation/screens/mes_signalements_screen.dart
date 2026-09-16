import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/report_provider.dart';
import '../../presentation/widgets/detail_bottom_sheet.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/report_card.dart';

class MesSignalementsScreen extends ConsumerWidget {
  const MesSignalementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(reportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes signalements')),
      body: async.when(
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'Aucun signalement pour le moment')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, i) => ReportCard(
                  report: items[i],
                  onTap: () => DetailBottomSheet.show(
                    context,
                    title: items[i].type.label,
                    child: Text(items[i].description),
                  ),
                ),
              ),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les signalements : $e',
          onRetry: () => ref.invalidate(reportProvider),
        ),
      ),
    );
  }
}