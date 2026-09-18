import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/models/report.dart';
import '../providers/service_providers.dart';
import '../widgets/report_map.dart';

class DetailsSignalementScreen extends ConsumerWidget {
  final Report report;

  const DetailsSignalementScreen({super.key, required this.report});

  Color get _statusColor => switch (report.status) {
        ReportStatus.pending => Colors.orange,
        ReportStatus.traite => Colors.green,
        ReportStatus.rejete => Colors.red,
      };

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le signalement'),
        content: const Text(
          'Cette action est définitive. Voulez-vous continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(reportRepositoryProvider).deleteReport(report);
    if (!context.mounted) return;

    SnackBarUtils.showSuccess(context, 'Signalement supprimé');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du signalement')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildStatusHeader(),
          const SizedBox(height: 24),
          if (report.photoUrl != null) ...[
            Text(
              'Preuve photo',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                report.photoUrl!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            'Informations',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.category_outlined,
                    label: 'Type',
                    value: report.type.label,
                  ),
                  const Divider(height: 24),
                  _buildInfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date d\'envoi',
                    value: AppDateUtils.formatDateTime(report.createdAt),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                report.description,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLocationSection(context),
          const SizedBox(height: 32),
          FilledButton.tonalIcon(
            onPressed: () => _delete(context, ref),
            style: FilledButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Supprimer ce signalement'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, color: _statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statut actuel',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Text(
                report.status.label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final latitude = report.latitude;
    final longitude = report.longitude;

    if (latitude == null || longitude == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              ReportMap(latitude: latitude, longitude: longitude),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
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