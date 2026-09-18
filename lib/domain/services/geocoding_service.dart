abstract class GeocodingService {
  /// Transforme latitude/longitude en adresse lisible.
  /// Retourne null si le service ne trouve rien.
  Future<String?> getAddress(double latitude, double longitude);
}

/// Clé de cache pour le provider Riverpod (identifiant par position).
class Coords {
  final double latitude;
  final double longitude;
  const Coords(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coords &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
