import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/report.dart';
import '../../presentation/providers/report_provider.dart';
import '../../presentation/providers/service_providers.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/report_card.dart';
import 'details_signalement_screen.dart';

class MesSignalementsScreen extends ConsumerStatefulWidget {
  const MesSignalementsScreen({super.key});

  @override
  ConsumerState<MesSignalementsScreen> createState() =>
      _MesSignalementsScreenState();
}

class _MesSignalementsScreenState extends ConsumerState<MesSignalementsScreen> {
  final Set<String> _deletedIds = {};

  Future<bool> _confirmDelete(Report report) async {
    try {
      await ref
          .read(reportRepositoryProvider)
          .deleteReport(report);
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de supprimer le signalement')),
      );
      return false;
    }
    if (!mounted) return false;
    setState(() => _deletedIds.add(report.id));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(reportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes signalements')),
      body: async.when(
        data: (items) {
          final visible = items
              .where((r) => !_deletedIds.contains(r.id))
              .toList();

          if (visible.isEmpty) {
            return const EmptyState(message: 'Aucun signalement pour le moment');
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: visible.length,
            itemBuilder: (context, i) {
              final report = visible[i];
              return Dismissible(
                key: ValueKey('report-${report.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmDelete(report),
                child: ReportCard(
                  report: report,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DetailsSignalementScreen(report: report),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: 'Impossible de charger les signalements : $e',
          onRetry: () {
            _deletedIds.clear();
            ref.invalidate(reportProvider);
          },
        ),
      ),
    );
  }
}