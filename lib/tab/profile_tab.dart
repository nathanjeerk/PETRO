import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? profileImageUrl;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadProfilePic();
  }

  Future<void> loadProfilePic() async {
    try {
      final url = await FirebaseStorage.instance
          .ref('profilePics/${user!.uid}.jpg')
          .getDownloadURL();
      setState(() {
        profileImageUrl = url;
      });
    } catch (_) {
      // No profile picture yet
    }
  }

  Future<void> uploadProfilePic() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await FirebaseStorage.instance
          .ref('profilePics/${user!.uid}.jpg')
          .putFile(file);
      await loadProfilePic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          GestureDetector(
            onTap: uploadProfilePic,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'PetLover_01',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            FirebaseAuth.instance.currentUser!.uid,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: FirebaseAuth.instance.currentUser!.uid),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('UID copied to clipboard!')),
              );
            },
            icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
            label: const Text(
              "Copy UID",
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),

          const SizedBox(height: 16),
          const _PhotoStats(),
          const SizedBox(height: 24),
          const _PhotoGrid(),
        ],
      ),
    );
  }
}

class _PhotoStats extends StatelessWidget {
  const _PhotoStats({super.key});

  @override
  Widget build(BuildContext context) {
    // You can make these dynamic later
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _StatItem(value: '12', label: 'Photos'),
        SizedBox(width: 24),
        _StatItem(value: '7', label: 'Friends'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.tealAccent),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          itemCount: docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final imageUrl = docs[index]['imageUrl'];
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }
}
