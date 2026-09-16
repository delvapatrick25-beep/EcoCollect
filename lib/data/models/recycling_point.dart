class RecyclingPoint {
  final String id;
  final String nom;
  final String adresse;
  final double latitude;
  final double longitude;
  final List<String> typesAcceptes;

  const RecyclingPoint({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.latitude,
    required this.longitude,
    required this.typesAcceptes,
  });
}