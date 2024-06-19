import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/firestore.dart';
import '../models/userModel.dart';

class PostNewJobScreen extends StatefulWidget {
  @override
  _PostNewJobScreenState createState() => _PostNewJobScreenState();
}

class _PostNewJobScreenState extends State<PostNewJobScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();

  final List<String> industries = ['Software', 'Finance', 'Pharmaceuticals'];
  String _selectedIndustry = 'Software';

  @override
  Widget build(BuildContext context) {
    final _currentOrganization = Provider.of<UserModel>(context).user as Organization;
    Future<void> _postJob() async {
      final salaryAsNumber = int.tryParse(_salaryController.text);
      final job = JobPost(
        organization: _currentOrganization,
        organizationUid: _currentOrganization.uid,
        title: _titleController.text,
        location: _locationController.text,
        industry: Industry.values.firstWhere((e) => e.toString() == 'Industry.' + _selectedIndustry),
        description: _descriptionController.text,
        imageURL: 'assets/images/facebook.webp',
        salary: salaryAsNumber?.toDouble() ?? 0.0,
      );


      // Clear the text fields
      _titleController.clear();
      _locationController.clear();
      _descriptionController.clear();

      FirestoreService().createJobPost(job);

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a New Job'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => null,
              child: const CircleAvatar(
                radius: 40,
                // backgroundImage: AssetImage(), // from assets/image/logo.png
                child: Icon(Icons.add_photo_alternate, size: 40)
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Job Title',
                hintText: 'Enter job title',
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Job Location',
                hintText: 'Enter job location',
              ),
              controller: _locationController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Job Description',
                hintText: 'Enter job description',
              ),
              maxLines: null,
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Salary',
                hintText: 'Enter salary (in \$)',
              ),
              keyboardType: TextInputType.number,
              controller: _salaryController,
            ),
            OutlinedButton(
              onPressed: () => null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.upload),
                  SizedBox(width: 8),
                  Text('Upload Job Poster'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _postJob,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text('Post Job', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

