import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signalement supprimé')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du signalement')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (report.photoUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                report.photoUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildStatusBadge(),
          const SizedBox(height: 16),
          _buildInfoTile(
            icon: Icons.warning_amber_outlined,
            label: 'Type',
            value: report.type.label,
          ),
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: AppDateUtils.formatDateTime(report.createdAt),
          ),
          const SizedBox(height: 4),
          _buildLocationSection(),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            report.description,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => _delete(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Supprimer le signalement'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    final latitude = report.latitude;
    final longitude = report.longitude;

    if (latitude == null || longitude == null) {
      return _buildInfoTile(
        icon: Icons.location_off_outlined,
        label: 'Localisation',
        value: 'Non disponible',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          label: 'Localisation',
          value: '${latitude.toStringAsFixed(5)}, '
              '${longitude.toStringAsFixed(5)}',
        ),
        const Text(
          'Localisation du signalement',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        ReportMap(latitude: latitude, longitude: longitude),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          report.status.label,
          style: TextStyle(
            color: _statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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