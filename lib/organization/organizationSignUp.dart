import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/userModel.dart';
import '../backend/firestore.dart';

class OrganizationSignUp extends StatefulWidget {
  @override
  _OrganizationSignUpState createState() => _OrganizationSignUpState();
}

class _OrganizationSignUpState extends State<OrganizationSignUp> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  final _auth = FirebaseAuth.instance;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();

  void _trySignUp() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_password == _confirmPassword) {
        try {
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          if (userCredential.user != null) {
            Organization newOrganization = Organization(
              email: _email,
              fullName: _fullName,
              uid: userCredential.user!.uid,
              posts: []
            );

            await FirestoreService().createOrganization(newOrganization);

            await Provider.of<UserModel>(context, listen: false).fetchUser(newOrganization.uid);
            if (Provider.of<UserModel>(context, listen: false).user is Organization) {
              Navigator.pushReplacementNamed(context, '/organization_home');
            }
          }
        } on FirebaseAuthException catch (e) {
          // Handle sign up failure (e.g., show an error message)
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        }
      } else {
        print('Password and confirm password do not match.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up!'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logo.png', // Replace with your asset image path
                    height: 180,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create an organization account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Swipe through hundreds of job openings and find the perfect match for you',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Organization Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _fullName = value!,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value!,
                    focusNode: _emailFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value!,
                    focusNode: _passwordFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordConfirmFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Repeat Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Confirm password can\'t be empty' : null,
                    onSaved: (value) => _confirmPassword = value!,
                    focusNode: _passwordConfirmFocusNode,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _trySignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Get Started', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}