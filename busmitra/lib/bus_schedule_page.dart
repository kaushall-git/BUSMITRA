import 'package:flutter/material.dart';

class BusSchedulePage extends StatelessWidget {
  const BusSchedulePage({super.key});

  final List<Map<String, String>> busSchedule = const [
    {
      "busNumber": "534",
      "source": "Anand Vihar",
      "destination": "Mehrauli",
      "departure": "06:30 AM",
      "arrival": "08:15 AM",
    },
    {
      "busNumber": "611",
      "source": "Nehru Place",
      "destination": "Najafgarh",
      "departure": "07:00 AM",
      "arrival": "08:45 AM",
    },
    {
      "busNumber": "764",
      "source": "Lajpat Nagar",
      "destination": "Jahangirpuri",
      "departure": "07:30 AM",
      "arrival": "09:00 AM",
    },
    {
      "busNumber": "990",
      "source": "Rohini Sector 22",
      "destination": "Badarpur",
      "departure": "08:00 AM",
      "arrival": "09:50 AM",
    },
    {
      "busNumber": "423",
      "source": "Sarai Kale Khan",
      "destination": "Dhaula Kuan",
      "departure": "08:30 AM",
      "arrival": "10:00 AM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delhi Bus Schedule'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: busSchedule.length,
        itemBuilder: (context, index) {
          final bus = busSchedule[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  bus["busNumber"]!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                "${bus["source"]} → ${bus["destination"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Dep: ${bus["departure"]} | Arr: ${bus["arrival"]}"),
            ),
          );
        },
      ),
    );
  }
}
