import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './components/bottomBar.dart';
import '../backend/firestore.dart';
import '../models/userModel.dart';

class OrganizationHomeScreen extends StatefulWidget {
  @override
  _OrganizationHomeScreenState createState() => _OrganizationHomeScreenState();
}

class _OrganizationHomeScreenState extends State<OrganizationHomeScreen> {
  final _firestoreService = FirestoreService();
  List<JobPost> jobPostings = [];

  @override
  void initState() {
    super.initState();
    _fetchJobPostings();
  }

  Future<void> _fetchJobPostings() async {
    final uid = Provider.of<UserModel>(context, listen: false).user!.uid;
    jobPostings = await _firestoreService.getOrganizationJobPosts(uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyred', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: jobPostings.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      // Placeholder for organization image
                      backgroundImage: Image.asset(jobPostings[index].imageURL).image,
                    ),
                    title: Text(jobPostings[index].title),
                    subtitle: Text('May 23'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Handle view job posting
                      Navigator.pushNamed(context, '/view_matches', arguments: jobPostings[index]);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/post_new_job');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text('Post New Job', style: TextStyle(fontSize: 16, color: Colors.white)
                )
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(index: 0),
    );
  }
}


