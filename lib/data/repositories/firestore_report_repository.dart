import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../mappers/report_mapper.dart';
import '../models/report.dart';
import '../services/firestore_service.dart';
import 'report_repository.dart';

class FirestoreReportRepository implements ReportRepository {
  FirestoreReportRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<List<Report>> listenMine(String userId) {
    return _firestoreService
        .collection(FirestoreCollections.reports)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(ReportMapper.fromMap).toList(),
        );
  }

  @override
  Future<String> addReport({
    required String userId,
    required ReportType type,
    required String description,
    double? latitude,
    double? longitude,
    Uint8List? photoBytes,
  }) async {
    final doc = _firestoreService
        .collection(FirestoreCollections.reports)
        .doc();

    await doc.set(<String, Object?>{
      'reportId': doc.id,
      'userId': userId,
      'type': type.name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'status': ReportStatus.pending.name,
    });

    return doc.id;
  }

  @override
  Future<void> deleteReport(Report report) {
    return _firestoreService.deleteDocument(
      FirestoreCollections.reports,
      report.id,
    );
  }
}