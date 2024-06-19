import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './backend/firestore.dart';
import './models/userModel.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _auth = FirebaseAuth.instance;
  final _passwordFocusNode = FocusNode();

  void _trySignIn() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (userCredential.user != null) {
          await Provider.of<UserModel>(context, listen: false).fetchUser(userCredential.user!.uid);

          if (Provider.of<UserModel>(context, listen: false).user is Applicant) {
            Navigator.pushReplacementNamed(context, '/applicant_home');
          } else if (Provider.of<UserModel>(context, listen: false).user is Organization) {
            Navigator.pushReplacementNamed(context, '/organization_home');
          }
        }
      } on FirebaseAuthException catch (e) {
        // Handle sign in failure (e.g., show an error message)
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else if (e.code == 'invalid-email') {
          print('Invalid email provided.');
        }
      }
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In!'),
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
                  Image.asset(
                    "assets/images/logo.png",
                    width: 250,
                    height: 250,
                  ),
                const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue searching for your next great thing!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value != null && value.isEmpty) ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value!,
                    initialValue: _email,
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
                    validator: (value) => (value != null && value.isEmpty) ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value!,
                    initialValue: _password,
                    focusNode: _passwordFocusNode,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _trySignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Sign In', style: TextStyle(color: Colors.white)),
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