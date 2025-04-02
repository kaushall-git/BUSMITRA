import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class BusTrackingPage extends StatefulWidget {
  final String busId;

  const BusTrackingPage({super.key, required this.busId});

  @override
  State<BusTrackingPage> createState() => _BusTrackingPageState();
}

class _BusTrackingPageState extends State<BusTrackingPage> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('bus_locations');
  DatabaseReference? _locationRef;
  LatLng? _busLocation;

  @override
  void initState() {
    super.initState();
    _listenToBusLocation();
  }

  void _listenToBusLocation() {
    _locationRef = _databaseRef.child(widget.busId);
    _locationRef!.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _busLocation = LatLng(
            data['latitude'] as double,
            data['longitude'] as double,
          );
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('busLocation'),
              position: _busLocation!,
              infoWindow: const InfoWindow(title: 'Your Bus'),
            ),
          );
        });

        if (_mapController != null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_busLocation!),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _locationRef?.onValue.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Bus'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _busLocation ?? const LatLng(0, 0),
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}