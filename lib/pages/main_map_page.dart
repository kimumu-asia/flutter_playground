import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMap extends StatefulWidget {
  @override
  State<MainMap> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(35.879061, 128.627954);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('Dongdaegu'),
            position: _center,
            infoWindow: InfoWindow(
              title: "동대구역",
              snippet: "동대구역 광장",
            ),
          )
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
