enum ReportType {
  depotSauvage('Dépôt sauvage'),
  poubelleDebordee('Poubelle débordée'),
  collecteNonEffectuee('Collecte non effectuée'),
  autre('Autre');

  final String label;

  const ReportType(this.label);
}

enum ReportStatus {
  pending('En attente'),
  traite('Traité'),
  rejete('Rejeté');

  final String label;

  const ReportStatus(this.label);
}

class Report {
  final String id;
  final String userId;
  final ReportType type;
  final String description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final ReportStatus status;

  const Report({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.status = ReportStatus.pending,
  });

  Report copyWith({
    String? id,
    String? userId,
    ReportType? type,
    String? description,
    String? photoUrl,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    ReportStatus? status,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}