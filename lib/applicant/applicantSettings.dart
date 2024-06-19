import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../backend/firestore.dart';
import '../models/userModel.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _bio = '';
  final List<String> industries = ['Software', 'Finance', 'Pharmaceuticals']; // Replace with your industries
  String _selectedIndustry = 'Software';
  final _auth = FirebaseAuth.instance;

  void _updateProfile() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      Provider.of<UserModel>(context, listen: false).updateApplicant(_fullName, _bio, Industry.Software);
    }
  }

  void _logout() async {
    await _auth.signOut();
    // Navigate to the login page after logout
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                _auth.currentUser!.email ?? 'No email found',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              // Text saying they can update profile details
              const Text(
                'Update your profile details:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _fullName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _bio = value!,
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField(
                borderRadius: BorderRadius.circular(8.0),
                style: const TextStyle(color: Colors.black),
                value: _selectedIndustry,
                items: industries.map((industry) {
                  return DropdownMenuItem(
                    value: industry,
                    child: Text(industry),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedIndustry = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Industry',
                  hintText: 'Select industry',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 32.0, right: 32.0)
                ),
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 32.0, right: 32.0)
                ),
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}