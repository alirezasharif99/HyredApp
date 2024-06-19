import 'package:flutter/material.dart';

import '../backend/firestore.dart';

class MatchesForJobPostScreen extends StatefulWidget {
  @override
  _MatchesForJobPostScreenState createState() => _MatchesForJobPostScreenState();
}

class _MatchesForJobPostScreenState extends State<MatchesForJobPostScreen> {
  List<Applicant> matches = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    final jobPost = ModalRoute.of(context)!.settings.arguments as JobPost;
    final matchUids = jobPost.applicantLikes.where((uid) => jobPost.organizationLikes.contains(uid)).toList();

    for (final uid in matchUids) {
      final user = await FirestoreService().getApplicant(uid);
      if (user != null) {
        matches.add(user);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches for ${(ModalRoute.of(context)!.settings.arguments as JobPost).title}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Action to find more matches
                Navigator.pushReplacementNamed(context, '/organization_swipe', arguments: ModalRoute.of(context)!.settings.arguments);
              },
              child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Find More Matches')),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: Image.asset('assets/images/headshot.webp').image, // Placeholder image
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(match.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(match.bio),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            // Handle message action
                            Navigator.pushReplacementNamed(context, '/messaging');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

