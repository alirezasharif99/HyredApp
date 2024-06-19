import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(),
              Image.asset(
                "assets/images/brand.png",
                width: 250,
                height: 250,
              ),
              Spacer(),
              Text(
                'Welcome to Hyred, let\'s find your dream job',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hyred is the ultimate job search app. Start swiping and find your perfect match.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 72),
              ElevatedButton(
                child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Handle next button press
                  Navigator.pushNamed(context, '/applicant_sign_up');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Not An Applicant? Sign up your organization here!', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  // Handle next button press
                  Navigator.pushNamed(context, '/organization_sign_up');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              TextButton(
                child: Text('Already have an account? Log in.', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  // Handle log in by navigating to applicantSignIn
                  Navigator.pushNamed(context, '/sign_in');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
