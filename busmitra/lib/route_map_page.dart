import 'package:flutter/material.dart';

class RouteMapPage extends StatelessWidget {
  const RouteMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map - Bus Mitra'),
      ),
      body: const Center(
        child: Text('Route Map will be displayed here.'),
      ),
    );
  }
}