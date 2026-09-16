import 'dart:typed_data';

import '../models/report.dart';

abstract class ReportRepository {
  Stream<List<Report>> listenMine(String userId);

  Future<String> addReport({
    required String userId,
    required ReportType type,
    required String description,
    double? latitude,
    double? longitude,
    Uint8List? photoBytes,
  });

  Future<void> deleteReport(Report report);
}