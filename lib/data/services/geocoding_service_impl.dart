import 'package:geocoding/geocoding.dart';

import '../../domain/services/geocoding_service.dart';

class GeocodingServiceImpl implements GeocodingService {
  final Geocoding _geocoding = Geocoding();

  @override
  Future<String?> getAddress(double latitude, double longitude) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return null;

      final first = placemarks.first;
      final parts = <String>[
        if (_isNotEmpty(first.street)) first.street!,
        if (_isNotEmpty(first.subLocality)) first.subLocality!,
        if (_isNotEmpty(first.locality)) first.locality!,
        if (_isNotEmpty(first.subAdministrativeArea)) first.subAdministrativeArea!,
        if (_isNotEmpty(first.administrativeArea)) first.administrativeArea!,
        if (_isNotEmpty(first.country)) first.country!,
      ];

      final unique = <String>[];
      for (final part in parts) {
        if (!unique.contains(part)) unique.add(part);
      }

      final address = unique.join(', ');
      return address;
    } catch (_) {
      return null;
    }
  }

  bool _isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;
}