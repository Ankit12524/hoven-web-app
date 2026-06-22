import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMapResponsive extends StatelessWidget {
  final LatLng hovenLocation = LatLng(28.6737348, 77.1169224);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: hovenLocation,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId("H'oven"),
            position: hovenLocation,
            infoWindow: InfoWindow(title: "H'oven"),
          ),
        },
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true, // static mini map
        tiltGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,


      ),
    );
  }
}
