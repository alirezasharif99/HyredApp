import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/userModel.dart';
import '../backend/firestore.dart';

class ApplicantOnboardingScreen extends StatefulWidget {
  @override
  _ApplicantOnboardingScreenState createState() => _ApplicantOnboardingScreenState();
}

class _ApplicantOnboardingScreenState extends State<ApplicantOnboardingScreen> {
  final List<String> industries = ['Software', 'Finance', 'Pharmaceuticals']; // Replace with your industries
  String _selectedIndustry = 'Software';
  String _bio = '';
  List<String> _skills = [];

  void _updateApplicant() async {
    final currentApplicant = Provider.of<UserModel>(context, listen: false).user as Applicant;

    try {
      final userIndustry = Industry.values.firstWhere((element) => element.toString() == 'Industry.' + _selectedIndustry);
      Provider.of<UserModel>(context, listen: false).updateApplicant(currentApplicant.fullName, _bio, userIndustry, _skills);
      Navigator.pushReplacementNamed(context, '/job_swipe');
    } catch (e) {
      print(e);
      // Handle update failure (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Your Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Hey there! We want to get to know you a bit better!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us about yourself so we can help you find the perfect role',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    _bio = value;
                  },
                ),
                const SizedBox(height: 32),
                TextField(
                  onSubmitted: (value) {
                    setState(() {
                      _skills.add(value);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Skill',
                    hintText: 'Enter a skill',
                  ),
                ),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: _skills.map((skill) => Chip(
                    label: Text(skill),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        _skills.remove(skill);
                      });
                    },
                  )).toList(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _updateApplicant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Get Started', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}