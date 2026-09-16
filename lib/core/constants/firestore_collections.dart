class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String collections = 'collections';
  static const String recyclingPoints = 'recycling_points';
  static const String tips = 'tips';
  static const String reports = 'reports';

  static String reportPhotoPath(String uid, String reportId) =>
      'reports/$uid/$reportId.jpg';
}