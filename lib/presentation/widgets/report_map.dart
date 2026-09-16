import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const ReportMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);

    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('report-location'),
              position: position,
            ),
          },
          myLocationEnabled: false,
          zoomControlsEnabled: true,
        ),
      ),
    );
  }
}