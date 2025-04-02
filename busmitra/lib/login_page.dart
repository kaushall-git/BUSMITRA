import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import the dashboard
import 'staff_dashboard.dart'; // Import the staff dashboard
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Declare and initialize the TextEditingController
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isOtpSent = false;
  bool _isStaffLogin = false; // To toggle between Passenger and Staff login
  int _remainingTime = 60;
  Timer? _timer;

  void _sendOTP() {
    if (_mobileController.text.isEmpty || _mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit mobile number!")),
      );
      return;
    }

    setState(() {
      _isOtpSent = true;
      _startTimer();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent successfully! (Mock: Use 123456)")),
    );
  }

  void _startTimer() {
    _remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _verifyOTP() {
    if (_otpController.text.isEmpty || _otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP!")),
      );
      return;
    }

    // Mock verification
    if (_otpController.text == "123456") {
      _timer?.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP! Please try again.")),
      );
    }
  }

  void _staffLogin() {
    if (_staffIdController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Staff ID and Password!")),
      );
      return;
    }

    // Mock verification for Staff login
    if (_staffIdController.text == "staff123" && _passwordController.text == "password123") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StaffDashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Staff ID or Password!")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    _otpController.dispose();
    _staffIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Bus Mitra'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Text
              const Text(
                'Welcome to Bus Mitra',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              // Toggle between Passenger and Staff Login
              ToggleButtons(
                isSelected: [_isStaffLogin, !_isStaffLogin],
                onPressed: (index) {
                  setState(() {
                    _isStaffLogin = index == 0;
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Login as Staff'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Login as Passenger'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Passenger Login UI
              if (!_isStaffLogin) ...[
                TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 20),

                // OTP Field (Conditional)
                if (_isOtpSent) ...[
                  TextField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text('Verify OTP'),
                  ),
                ],

                // Send OTP Button (Conditional)
                if (!_isOtpSent)
                  ElevatedButton(
                    onPressed: _sendOTP,
                    child: const Text('Send OTP'),
                  ),
              ],

              // Staff Login UI
              if (_isStaffLogin) ...[
                TextField(
                  controller: _staffIdController,
                  decoration: const InputDecoration(
                    labelText: 'Staff ID',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _staffLogin,
                  child: const Text('Login as Staff'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}