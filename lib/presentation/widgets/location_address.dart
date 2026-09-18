import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/services/geocoding_service.dart';
import '../providers/service_providers.dart';

/// Résout l'adresse lisible à partir des coordonnées (reverse geocoding).
final addressProvider = FutureProvider.autoDispose
    .family<String?, Coords>((ref, coords) {
  return ref
      .watch(geocodingServiceProvider)
      .getAddress(coords.latitude, coords.longitude);
});

/// Affiche l'adresse humaine d'une position, avec repli sur les coordonnées.
class LocationAddress extends ConsumerWidget {
  final double latitude;
  final double longitude;
  final String? fallbackText;

  const LocationAddress({
    super.key,
    required this.latitude,
    required this.longitude,
    this.fallbackText = 'Coordonnées disponibles',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coords = Coords(latitude, longitude);
    final addressAsync = ref.watch(addressProvider(coords));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: addressAsync.when(
                loading: () => const Text(
                  'Recherche de l\'adresse...',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                error: (_, _) => const Text('Localisation non disponible'),
                data: (address) => Text(
                  address ?? '$fallbackText · $latitude, $longitude',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}