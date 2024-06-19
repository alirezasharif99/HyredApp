import 'package:flutter/material.dart';

class SignInChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Contains two buttons for Applicant or Organization
              ElevatedButton(
                child: Text('Applicant', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Handle next button press
                  Navigator.pushReplacementNamed(context, '/applicant_home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Organization', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  // Handle next button press
                  Navigator.pushReplacementNamed(context, '/organization_home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
