import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'database_helper.dart'; // Import the database helper

class BookTicketPage extends StatefulWidget {
  const BookTicketPage({super.key, required Null Function(dynamic fare) onTicketBooked, required double walletBalance});

  @override
  State<BookTicketPage> createState() => _BookTicketPageState();
}

class _BookTicketPageState extends State<BookTicketPage> {
  final List<String> stations = [
    'Delhi Junction (Old Delhi)',
    'New Delhi Railway Station',
    'Hazrat Nizamuddin',
    'Anand Vihar Terminal',
    'Sarai Rohilla',
    'Shivaji Bridge',
    'Tughlakabad'
  ];

  final List<String> passengerServices = [
    'None',
    'Pregnant Lady',
    'Children',
    'Old Age Person',
  ];

  String? selectedDeparture;
  String? selectedDestination;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _passengerController = TextEditingController();
  String? selectedService;
  bool _isPaymentSuccessful = false;
  String? _qrData;

  final DatabaseHelper _dbHelper = DatabaseHelper(); // Database helper instance

  void _showFare() {
    if (selectedDeparture == null ||
        selectedDestination == null ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _passengerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields!")),
      );
      return;
    }

    // Mock fare calculation
    double fare = 50.0 * int.parse(_passengerController.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fare Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total Fare: ₹${fare.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPaymentOptions(fare);
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions(double fare) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                title: const Text('Wallet'),
                onTap: () {
                  Navigator.pop(context);
                  _processWalletPayment(fare);
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.green),
                title: const Text('Credit/Debit Card'),
                onTap: () {
                  Navigator.pop(context);
                  _processCardPayment(fare);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processWalletPayment(double fare) async {
    // Mock wallet payment process
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet Payment'),
        content: Text('Pay ₹${fare.toStringAsFixed(2)} from your wallet?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isPaymentSuccessful = true;
                _qrData =
                "Departure: $selectedDeparture\nDestination: $selectedDestination\nDate: ${_dateController.text}\nTime: ${_timeController.text}\nPassengers: ${_passengerController.text}\nService: $selectedService";
              });

              // Save ticket data to the database
              final ticket = {
                'departure': selectedDeparture,
                'destination': selectedDestination,
                'date': _dateController.text,
                'time': _timeController.text,
                'passengers': int.parse(_passengerController.text),
                'service': selectedService,
                'qrData': _qrData,
              };
              await _dbHelper.insertTicket(ticket);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Successful!")),
              );
            },
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _processCardPayment(double fare) async {
    // Mock card payment process
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Expiry Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isPaymentSuccessful = true;
                _qrData =
                "Departure: $selectedDeparture\nDestination: $selectedDestination\nDate: ${_dateController.text}\nTime: ${_timeController.text}\nPassengers: ${_passengerController.text}\nService: $selectedService";
              });

              // Save ticket data to the database
              final ticket = {
                'departure': selectedDeparture,
                'destination': selectedDestination,
                'date': _dateController.text,
                'time': _timeController.text,
                'passengers': int.parse(_passengerController.text),
                'service': selectedService,
                'qrData': _qrData,
              };
              await _dbHelper.insertTicket(ticket);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Successful!")),
              );
            },
            child: const Text('Pay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Ticket - Bus Mitra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Departure Station Dropdown
            DropdownButtonFormField<String>(
              value: selectedDeparture,
              items: stations.map((station) {
                return DropdownMenuItem<String>(
                  value: station,
                  child: Text(station),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDeparture = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Depart from',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Destination Station Dropdown
            DropdownButtonFormField<String>(
              value: selectedDestination,
              items: stations.map((station) {
                return DropdownMenuItem<String>(
                  value: station,
                  child: Text(station),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDestination = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Date Field
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date of Travel',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 16),

            // Time Field
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time of Travel',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  _timeController.text = pickedTime.format(context);
                }
              },
            ),
            const SizedBox(height: 16),

            // Number of Passengers
            TextField(
              controller: _passengerController,
              decoration: const InputDecoration(
                labelText: 'Number of Passengers',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Passenger Service Dropdown
            DropdownButtonFormField<String>(
              value: selectedService,
              items: passengerServices.map((service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Passenger Service',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Show Fare Button
            ElevatedButton(
              onPressed: _showFare,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('SHOW FARE'),
            ),
            const SizedBox(height: 16),

            // Display QR Code
            if (_isPaymentSuccessful)
              Column(
                children: [
                  const Text(
                    'Your Ticket QR Code:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: _qrData!,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}