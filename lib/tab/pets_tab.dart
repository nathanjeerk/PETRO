import 'package:flutter/material.dart';

class PetsTab extends StatelessWidget {
  const PetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Your Pets will appear here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
