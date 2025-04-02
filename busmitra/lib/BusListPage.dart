import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'track_bus_page.dart'; // Import the TrackBusPage

class BusListPage extends StatelessWidget {
  const BusListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded list of buses in Delhi
    final List<Map<String, dynamic>> buses = [
      {
        'busNumber': 'DL-01-1234',
        'source': 'Anand Vihar ISBT',
        'destination': const LatLng(28.5495, 77.2527), // Nehru Place
        'currentLocation': const LatLng(28.6505, 77.3150), // Initial location
      },
      {
        'busNumber': 'DL-02-5678',
        'source': 'Kashmere Gate ISBT',
        'destination': const LatLng(28.6315, 77.2167), // Connaught Place
        'currentLocation': const LatLng(28.6667, 77.2333), // Initial location
      },
      {
        'busNumber': 'DL-03-9101',
        'source': 'Sarai Kale Khan ISBT',
        'destination': const LatLng(28.6248, 77.2107), // Rajiv Chowk
        'currentLocation': const LatLng(28.5833, 77.2000), // Initial location
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus'),
      ),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Bus Number: ${bus['busNumber']}'),
              subtitle: Text('${bus['source']} to ${bus['destination']}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackBusPage(bus: bus),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}