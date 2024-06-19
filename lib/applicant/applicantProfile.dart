import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './components/bottomBar.dart';
import '../models/userModel.dart';
import '../backend/firestore.dart';

class ApplicantProfileScreen extends StatefulWidget {
  @override
  _ApplicantProfileScreenState createState() => _ApplicantProfileScreenState();
}

class _ApplicantProfileScreenState extends State<ApplicantProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final user = userModel.user as Applicant;

    return Scaffold(
      bottomNavigationBar: const BottomBar(index: 4),
      appBar: AppBar(
        title: const Text('Applicant Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/applicant_settings');
            },
          ),
        ]
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: Image.asset('assets/images/headshot.webp').image,
                ),
                const SizedBox(height: 8),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  user.bio,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'View my job applications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: Image.asset('assets/images/google.webp').image,
                  ),
                  title: const Text('Software Engineer'),
                  subtitle: const Text('Google'),
                  trailing: const Text('1 day'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'View my saved offers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: Image.asset('assets/images/facebook.webp').image,
                      ),
                      label: const Text('PR Manager at Meta'),
                    ),
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: Image.asset('assets/images/amazon.webp').image,
                      ),
                      label: const Text('HR Assistant at Amazon'),
                    ),
                    // Add more chips for other saved offers...
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


