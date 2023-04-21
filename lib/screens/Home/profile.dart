import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meproject/services/databases.dart';
import 'package:provider/provider.dart';
import 'package:meproject/services/auth.dart';
import 'package:meproject/models/user.dart';
import 'package:meproject/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  final bool isSwitch;
  Profile({super.key,required this.isSwitch});
 

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('markdowns')
          .doc(user.uid)
          .get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        if (data['name'] != null) {
          _nameController.text = data['name'];
        }
        if (data['mobileNumber'] != null) {
          _mobileNumberController.text = data['mobileNumber'];
        }
        if (data['profession'] != null) {
          _professionController.text = data['profession'];
        }
        if (data['image'] != null) {
          _imageController.text = data['image'];
        } else {
          _imageController.text = '';
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String name = _nameController.text.trim();
      final String mobileNumber = _mobileNumberController.text.trim();
      final String profession = _professionController.text.trim();
      final String image = _imageController.text.trim();

      await FirebaseFirestore.instance
          .collection('markdownCollection')
          .doc(user.uid)
          .set({
        'name': name,
        'mobileNumber': mobileNumber,
        'profession': profession,
        'image': image,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isSwitch ? Colors.brown[100] : Colors.grey[600],
      appBar: AppBar(
        title: const Text("Profie"),
        backgroundColor: widget.isSwitch ? Colors.brown : Colors.grey,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_imageController.text),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                    ),
                  ),
                  TextFormField(
                    controller: _professionController,
                    decoration: const InputDecoration(
                      labelText: 'Profession',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
