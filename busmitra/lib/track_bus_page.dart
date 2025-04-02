import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackBusPage extends StatefulWidget {
  final Map<String, dynamic> bus; // Bus details

  const TrackBusPage({super.key, required this.bus});

  @override
  State<TrackBusPage> createState() => _TrackBusPageState();
}

class _TrackBusPageState extends State<TrackBusPage> {
  late GoogleMapController _mapController;
  LatLng? _busLocation; // Current bus location
  Set<Polyline> _polylines = {}; // To store the route polyline

  @override
  void initState() {
    super.initState();
    // Initialize _busLocation with the bus's current location
    _busLocation = widget.bus['currentLocation'] as LatLng?;
    if (_busLocation == null) {
      // Handle the case where currentLocation is not provided
      print('Error: currentLocation is null');
      _busLocation = const LatLng(28.6139, 77.2090); // Default location (Delhi)
    }
    _fetchRoute(); // Fetch the route when the page loads
    _simulateBusMovement(); // Simulate bus movement
  }

  // Fetch the route from the Directions API
  void _fetchRoute() async {
    const apiKey = 'AIzaSyAJO2D7m0sPz5LPcBWk3O9Kpsdlo6dUgdU'; // Replace with your API key
    final source = widget.bus['currentLocation'] as LatLng?;
    final destination = widget.bus['destination'] as LatLng?;

    if (source == null || destination == null) {
      print('Error: Source or destination is null');
      return;
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${source.latitude},${source.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        // Extract the polyline points from the response
        final points = data['routes'][0]['overview_polyline']['points'];
        final polylineCoordinates = _decodePolyline(points);

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 4,
            ),
          };
        });
      } else {
        print('Failed to fetch route: ${data['status']}');
      }
    } else {
      print('Failed to fetch route: ${response.statusCode}');
    }
  }
  // Decode the polyline points
  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // Simulate bus movement from source to destination
  void _simulateBusMovement() async {
    if (_busLocation == null) {
      print('Error: _busLocation is null');
      return;
    }

    const double step = 0.001; // Small step for simulation
    double lat = _busLocation!.latitude;
    double lng = _busLocation!.longitude;
    final destination = widget.bus['destination'] as LatLng?;

    if (destination == null) {
      print('Error: Destination is null');
      return;
    }

    while (lat < destination.latitude && lng < destination.longitude) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        lat += step;
        lng += step;
        _busLocation = LatLng(lat, lng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Bus: ${widget.bus['busNumber']}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _busLocation == null
                ? const Center(child: Text('Bus location not available'))
                : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _busLocation!,
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('bus'),
                  position: _busLocation!,
                  infoWindow: InfoWindow(
                    title: 'Bus ${widget.bus['busNumber']}',
                    snippet: '${widget.bus['source']} to ${widget.bus['destination']}',
                  ),
                ),
              },
              polylines: _polylines, // Use the fetched route polyline
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus Number: ${widget.bus['busNumber']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Route: ${widget.bus['source']} to ${widget.bus['destination']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Location: ${_busLocation?.latitude.toStringAsFixed(4) ?? 'N/A'}, ${_busLocation?.longitude.toStringAsFixed(4) ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}