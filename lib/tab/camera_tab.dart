import 'package:flutter/material.dart';

class CameraTab extends StatelessWidget {
  const CameraTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Camera Coming Soon',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
