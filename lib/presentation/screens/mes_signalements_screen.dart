import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/snackbar_utils.dart';
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
  ReportStatus? _selectedStatus;

  Future<bool> _confirmDelete(Report report) async {
    try {
      await ref
          .read(reportRepositoryProvider)
          .deleteReport(report);
    } catch (_) {
      if (!mounted) return false;
      SnackBarUtils.showError(context, 'Impossible de supprimer le signalement');
      return false;
    }
    if (!mounted) return false;
    SnackBarUtils.showSuccess(context, 'Signalement supprimé');
    setState(() => _deletedIds.add(report.id));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(reportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes signalements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: async.when(
        data: (items) {
          final visible = items
              .where((r) => !_deletedIds.contains(r.id))
              .where((r) => _selectedStatus == null || r.status == _selectedStatus)
              .toList();

          return Column(
            children: [
              _buildStatusFilter(),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(message: 'Aucun signalement trouvé')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                color: Theme.of(context).colorScheme.error,
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
                      ),
              ),
            ],
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

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Tous'),
            selected: _selectedStatus == null,
            onSelected: (selected) {
              if (selected) setState(() => _selectedStatus = null);
            },
          ),
          const SizedBox(width: 8),
          ...ReportStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(status.label),
                selected: _selectedStatus == status,
                onSelected: (selected) {
                  setState(() => _selectedStatus = selected ? status : null);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
