import 'package:flutter/material.dart';

import './components/bottomBar.dart';

class ApplicantHomeScreen extends StatelessWidget {
  final List<String> categories = ['New', 'Marketing', 'Sales', 'Software', 'Customer'];
  final List<Map<String, String>> messages = [
    {'title': 'Marketing Specialist - Amazon', 'subtitle': 'You have a new message!', 'time': 'Just now', 'image': 'assets/images/amazon.webp'},
    {'title': 'Sales Representative - Facebook', 'subtitle': 'Can we schedule a meeting for next week?', 'time': '12 min', 'image': 'assets/images/facebook.webp'},
    {'title': 'Software Engineer - Google', 'subtitle': "Hello, can you answer? What's wrong with your...", 'time': '1d', 'image': 'assets/images/google.webp'},
    // Add more messages if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(index: 0),
      appBar: AppBar(
        title: Text('Hyred'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for jobs or companies',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // Placeholder for user image
                    backgroundImage: Image.asset(messages[index]['image']!).image,
                  ),
                  title: Text(messages[index]['title']!),
                  subtitle: Text(messages[index]['subtitle']!),
                  trailing: Text(messages[index]['time']!),
                  onTap: () {
                    // Handle message tap
                    Navigator.pushReplacementNamed(context, '/messaging');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

