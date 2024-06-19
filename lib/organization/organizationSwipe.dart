import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:provider/provider.dart';
import './components/bottomBar.dart';
import '../backend/firestore.dart';
import '../models/userModel.dart';

class OrganizationSwipeScreen extends StatefulWidget {
  @override
  _OrganizationSwipeScreenState createState() => _OrganizationSwipeScreenState();
}

class _OrganizationSwipeScreenState extends State<OrganizationSwipeScreen> {
  List<Applicant> applicants = [];
  final _firestoreService = FirestoreService();
  JobPost? jobPost;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (applicants.isEmpty) {
      final uid = Provider.of<UserModel>(context).user?.uid;
      jobPost = ModalRoute.of(context)!.settings.arguments as JobPost?;

      // Default to the first job post if no job post is passed
      if (jobPost == null) {
        jobPost = (await _firestoreService.getOrganizationJobPosts(uid!))[0];
      }

      applicants = await _firestoreService.getUnlikedApplicants(jobPost!);
    }

    setState(() {});
  }

  int currentIndex = 0; // Variable to track the current index

  void matchCandidate(int index) async {
    await _firestoreService.likeApplicant(jobPost!.uid, applicants[index].uid);

    final isMatch = await _firestoreService.checkForMatch(jobPost!.uid, applicants[index].uid,);

    if (isMatch) {
      // Function to handle matching with a candidate
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('It\'s a match!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/headshot.webp'),
                Text('You have matched with ${applicants[currentIndex].fullName}!'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Say Hi!'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/organization_messaging"); // Navigate to the messaging screen
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((value) {
        print(index);
      });
    } else {
      setState(() {
        currentIndex = index; // Update the current index when the swiper index changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidate Profiles for "${jobPost?.title ?? 'Unknown'}" Job Post', style: const TextStyle(fontSize: 18)),
      ),
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.account_box, size: 50), // Placeholder for profile image
                  title: Text(applicants[index].fullName),
                  subtitle: Text(applicants[index].industry.name),
                  trailing: Chip(
                    label: const Text('Remote'),
                    backgroundColor: Colors.green[700],
                  ),
                ),
                Image.asset(
                  'assets/images/headshot.webp',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(applicants[index].bio),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: applicants[index].skills.map((skill) {
                        return Chip(
                          label: Text(skill),
                          backgroundColor: Colors.green[700],
                        );
                      }).toList(),
                    ),
                  ],)
                ),
                // Buttons to manually match (thumbs up or thumbs down icons)
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      onPressed: () {
                        // Handle thumbs down action
                        setState(() {
                          currentIndex += 1; // Update the current index when the swiper index changes
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {
                        // Handle thumbs up action
                        matchCandidate(index); // Call the matchCandidate function
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: applicants.length,
        layout: SwiperLayout.TINDER,
        itemWidth: 350.0,
        itemHeight: 600.0,
        index: currentIndex,
        onIndexChanged: (int index) {
          // Index gets smaller if you swipe right but loops to the start if you reach the end

          // This breaks if there is only two applicants
          bool indexIsSmaller = index < currentIndex;
          bool indexLoopedToStart = index == 0 && currentIndex == applicants.length - 1;
          bool indexLoopedToEnd = index == applicants.length - 1 && currentIndex == 0;
          bool swipedRight = (indexIsSmaller && !indexLoopedToStart) || indexLoopedToEnd;

          if (swipedRight) {
            matchCandidate(index); // Call the matchCandidate function
          } else {
            setState(() {
              currentIndex = index; // Update the current index when the swiper index changes
            });
          }
        },
      ),
      bottomNavigationBar: const BottomBar(index: 1),
    );
  }
}
