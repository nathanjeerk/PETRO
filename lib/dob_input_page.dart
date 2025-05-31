import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';
import 'package:intl/intl.dart';

class DOBInputPage extends StatefulWidget {
  final String name;
  const DOBInputPage({super.key, required this.name});

  @override
  State<DOBInputPage> createState() => _DOBInputPageState();
}

class _DOBInputPageState extends State<DOBInputPage> {
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your birthday',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // for dark mode picker
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _saveUserInfo() async {
    if (selectedDate == null) return;

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': widget.name,
          'dob': formattedDate,
          'createdAt': Timestamp.now(),
        }, SetOptions(merge: true));
      } else {
        await FirebaseFirestore.instance.collection('temp_users').add({
          'name': widget.name,
          'dob': formattedDate,
          'createdAt': Timestamp.now(),
        });
      }

      // ✅ If all works, navigate to Register
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
      );
    } catch (e) {
      debugPrint('❌ Error saving user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save info. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi ${widget.name}, when is your birthday?',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : 'Select your birthdate',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.white54),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveUserInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[700],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
