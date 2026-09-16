import 'package:flutter/material.dart';

import '../../data/models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (report.status) {
      ReportStatus.pending => Colors.orange,
      ReportStatus.traite => Colors.green,
      ReportStatus.rejete => Colors.red,
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.flag_outlined, color: statusColor),
        title: Text(report.type.label),
        subtitle: Text(
          '${report.status.label} — ${report.description}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}