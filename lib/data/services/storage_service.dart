import 'dart:typed_data';

abstract class StorageService {
  Future<String> uploadPhoto({
    required String uid,
    required String reportId,
    required Uint8List bytes,
  });

  Future<void> deletePhoto({
    required String uid,
    required String reportId,
  });
}