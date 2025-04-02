import 'package:flutter/material.dart';

class CheckVehicleConditionPage extends StatelessWidget {
  const CheckVehicleConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded bus data
    final List<Map<String, dynamic>> buses = [
      {
        'busNumber': 'DL-01-1234',
        'carbonEmission': '120 g/km',
        'lastServicing': '2023-09-15',
        'rating': 4.5,
      },
      {
        'busNumber': 'DL-02-5678',
        'carbonEmission': '110 g/km',
        'lastServicing': '2023-08-20',
        'rating': 4.0,
      },
      {
        'busNumber': 'DL-03-9101',
        'carbonEmission': '130 g/km',
        'lastServicing': '2023-07-10',
        'rating': 3.5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Vehicle Condition'),
      ),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Bus Number: ${bus['busNumber']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Carbon Emission: ${bus['carbonEmission']}'),
                  Text('Last Servicing: ${bus['lastServicing']}'),
                  Row(
                    children: [
                      const Text('Rating: '),
                      // Display star rating
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < bus['rating'] ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      Text(' (${bus['rating']})'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}