import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  /// Retourne la position actuelle ou null si la permission est refusée / indisponible.
  Future<Position?> getCurrentPosition();
}