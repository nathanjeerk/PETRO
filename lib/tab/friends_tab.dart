import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final uidController = TextEditingController();
  Map<String, dynamic>? friendData;

  Future<void> searchFriend() async {
    final inputUid = uidController.text.trim();
    if (inputUid.isEmpty) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(inputUid)
        .get();
    if (doc.exists) {
      setState(() => friendData = doc.data());
    } else {
      setState(() => friendData = null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find Friend by UID",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: uidController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter UID',
                    hintStyle: const TextStyle(color: Colors.white38),
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: searchFriend,
                child: const Text("Search"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (friendData != null)
            Card(
              color: Colors.grey[850],
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.tealAccent),
                title: Text(
                  friendData!['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  friendData!['email'],
                  style: const TextStyle(color: Colors.white60),
                ),
                trailing: Text(
                  friendData!['uid'].substring(0, 6),
                  style: const TextStyle(color: Colors.white30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
