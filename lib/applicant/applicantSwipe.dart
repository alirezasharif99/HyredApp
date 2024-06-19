import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:hyred/models/userModel.dart';
import 'package:provider/provider.dart';

import './components/bottomBar.dart';
import '../backend/firestore.dart';

class ApplicantSwipeScreen extends StatefulWidget {
  @override
  _ApplicantSwipeScreenState createState() => _ApplicantSwipeScreenState();
}

class _ApplicantSwipeScreenState extends State<ApplicantSwipeScreen> {
  List<JobPost> jobPosts = [];
  final _firestoreService = FirestoreService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final uid = Provider.of<UserModel>(context).user?.uid;
    jobPosts = await _firestoreService.getUnlikedJobPosts(uid!);

    setState(() {});
  }

  int currentIndex = 0; // Variable to track the current index

  void matchCandidate(int index) async {
    final uid = Provider.of<UserModel>(context, listen: false).user!.uid;
    await _firestoreService.likeJobPost(jobPosts[index].uid, uid);

    final isMatch = await _firestoreService.checkForMatch(jobPosts[index].uid, uid);

    if (isMatch) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('It\'s a match!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(jobPosts[currentIndex].imageURL),
                Text('You have matched with ${jobPosts[currentIndex].organization.fullName}!'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Say Hi!'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/messaging"); // Navigate to the messaging screen
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((value) {
        setState(() {
          currentIndex = index; // Update the current index when the swiper index changes
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Profiles'),
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
                  title: Text(jobPosts[index].title),
                  subtitle: Text(jobPosts[index].industry.name),
                  trailing: Chip(
                    label: Text(jobPosts[index].location),
                    backgroundColor: Colors.green[300],
                  ),
                ),
                Image.asset(
                  jobPosts[index].imageURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(jobPosts[index].description),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Salary: \$${jobPosts[index].salary.toString()}'),
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
                      icon: Icon(Icons.thumb_up),
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
        itemCount: jobPosts.length,
        layout: SwiperLayout.TINDER,
        itemWidth: 350.0,
        itemHeight: 600.0,
        index: currentIndex,
        onIndexChanged: (int index) {
          // Index gets smaller if you swipe right but loops to the start if you reach the end

          // This breaks if there is only two job posts
          bool indexIsSmaller = index < currentIndex;
          bool indexLoopedToStart = index == 0 && currentIndex == jobPosts.length - 1;
          bool indexLoopedToEnd = index == jobPosts.length - 1 && currentIndex == 0;
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
      bottomNavigationBar: const BottomBar(index: 2),
    );
  }
}
