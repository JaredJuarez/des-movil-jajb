import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? userPosition;
  GoogleMapController? controller;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Actividad Maps")),
      body: userPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (c) => controller = c,
              initialCameraPosition: CameraPosition(
                target: userPosition!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("posicion_usuario"),
                  position: userPosition!,
                  infoWindow: InfoWindow(title: "Mi ubicación"),
                ),
                Marker(
                  markerId: MarkerId("punto_fijo"),
                  position: LatLng(19.432608, -99.133209),
                  infoWindow: InfoWindow(title: "Punto fijo de ejemplo"),
                )
              },
              myLocationEnabled: true,
            ),
    );
  }
}