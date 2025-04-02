import 'dart:io';

import 'package:busmitra/Emergency.dart';
import 'package:busmitra/track_bus_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BusStatus.dart';
import 'bus_schedule_page.dart'; // Import the bus schedule page
import 'book_ticket_page.dart'; // Import the book ticket page
import 'route_map_page.dart'; // Import the route map page

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userName = "John Doe"; // Default user name
  String _userEmail = "john.doe@example.com"; // Default user email
  File? _profileImage; // To store the selected profile picture
  double _walletBalance = 1000.0; // Initial wallet balance

  void _updateProfile(String newName, String newEmail, File? newImage) {
    setState(() {
      _userName = newName;
      _userEmail = newEmail;
      _profileImage = newImage;
    });
  }

  void _rechargeWallet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recharge Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.blue),
                title: const Text('PhonePe'),
                onTap: () {
                  _processUpiPayment('PhonePe');
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text('Google Pay'),
                onTap: () {
                  _processUpiPayment('Google Pay');
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.orange),
                title: const Text('Amazon Pay'),
                onTap: () {
                  _processUpiPayment('Amazon Pay');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processUpiPayment(String upiApp) {
    // Mock UPI payment process
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('UPI Payment'),
        content: Text('Redirecting to $upiApp...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _walletBalance += 500.0; // Add ₹500 to the wallet
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Wallet Recharged Successfully!")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Bus Mitra'),
        actions: [
          IconButton(
            onPressed: () async {
              // Navigate to the edit profile page and wait for the result
              final updatedProfile = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    currentName: _userName,
                    currentEmail: _userEmail,
                    currentImage: _profileImage,
                  ),
                ),
              );

              // If the user saved changes, update the profile
              if (updatedProfile != null) {
                _updateProfile(
                  updatedProfile['name'],
                  updatedProfile['email'],
                  updatedProfile['image'],
                );
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User Profile Section
              UserProfileSection(
                userName: _userName,
                userEmail: _userEmail,
                profileImage: _profileImage,
              ),
              const SizedBox(height: 24),

              // Wallet Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Personal Wallet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Balance: ₹${_walletBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _rechargeWallet,
                        child: const Text('Recharge Wallet'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Features Grid
              GridView.count(
                crossAxisCount: 2, // 2 columns
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildFeatureButton(
                    context,
                    icon: Icons.schedule,
                    label: 'View Bus Schedule',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusSchedulePage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    icon: Icons.airplane_ticket,
                    label: 'Book Ticket',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookTicketPage(
                            walletBalance: _walletBalance,
                            onTicketBooked: (fare) {
                              setState(() {
                                _walletBalance -= fare;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    icon: Icons.directions_bus,
                    label: 'Track Buses',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackBusPage(bus: {},),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    icon: Icons.map,
                    label: 'View Route',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RouteMapPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    icon: Icons.car_repair,
                    label: 'Check Vehicle Condition',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckVehicleConditionPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    icon: Icons.emergency,
                    label: 'Emergency Report',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmergencyReportPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for feature buttons
  Widget _buildFeatureButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

// User Profile Section
class UserProfileSection extends StatelessWidget {
  final String userName;
  final String userEmail;
  final File? profileImage;

  const UserProfileSection({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!) // Use the selected image
                  : const AssetImage('assets/images/profile.png') as ImageProvider, // Default image
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final File? currentImage;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    this.currentImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _profileImage = widget.currentImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // Use the selected image
                    : const AssetImage('assets/images/profile.png') as ImageProvider, // Default image
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Return the updated profile data to the Dashboard
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'image': _profileImage,
                });
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}