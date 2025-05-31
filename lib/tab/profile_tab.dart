import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '/settings/settings_page.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row with Settings Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          Center(
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
                  user!.uid,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: user!.uid));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('UID copied to clipboard!')),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.tealAccent,
                  ),
                  label: const Text(
                    "Copy UID",
                    style: TextStyle(color: Colors.tealAccent),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const _PhotoStats(),
          const SizedBox(height: 20),
          const _PhotoGrid(),
        ],
      ),
    );
  }
}

class _PhotoStats extends StatelessWidget {
  const _PhotoStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _StatItem(label: "Photos", value: "12"),
        _StatItem(label: "Friends", value: "8"),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, color: Colors.white)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white54)),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid();

  @override
  Widget build(BuildContext context) {
    // Placeholder images - replace with dynamic images from Firestore later
    final List<String> samplePhotos = List.generate(
      6,
      (index) => 'https://placekitten.com/200/${200 + index}',
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: samplePhotos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(samplePhotos[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
