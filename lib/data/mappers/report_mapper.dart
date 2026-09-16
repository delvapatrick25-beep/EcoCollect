import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report.dart';

class ReportMapper {
  ReportMapper._();

  static Map<String, Object?> toMap(Report report) {
    return <String, Object?>{
      'reportId': report.id,
      'userId': report.userId,
      'type': report.type.name,
      'description': report.description,
      'photoUrl': report.photoUrl,
      'latitude': report.latitude,
      'longitude': report.longitude,
      'createdAt': Timestamp.fromDate(report.createdAt),
      'status': report.status.name,
    };
  }

  static Report fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Report(
      id: data['reportId'] as String? ?? snapshot.id,
      userId: data['userId'] as String,
      type: ReportTypeIn.fromName(data['type'] as String),
      description: data['description'] as String,
      photoUrl: data['photoUrl'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: ReportStatusIn.fromName(data['status'] as String),
    );
  }
}

/// Helpers `fromName` pour les enums ReportType / ReportStatus.
class ReportTypeIn {
  ReportTypeIn._();

  static ReportType fromName(String name) {
    return ReportType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => ReportType.autre,
    );
  }
}

class ReportStatusIn {
  ReportStatusIn._();

  static ReportStatus fromName(String name) {
    return ReportStatus.values.firstWhere(
      (s) => s.name == name,
      orElse: () => ReportStatus.pending,
    );
  }
}