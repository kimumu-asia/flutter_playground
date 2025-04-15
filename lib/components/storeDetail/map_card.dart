import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMapComponent extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final String addressDetail;

  const GoogleMapComponent({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.addressDetail,
  }) : super(key: key);

  @override
  State<GoogleMapComponent> createState() => _GoogleMapComponentState();
}

class _GoogleMapComponentState extends State<GoogleMapComponent> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(widget.latitude, widget.longitude);

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 16,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: position,
                ),
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '${widget.address} ${widget.addressDetail}',
                style: TextStyle(fontSize: 14),
              ),
            ),
            IconButton(
              icon: Text(
                '복사',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '${widget.address} ${widget.addressDetail}'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('주소가 복사되었습니다')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
