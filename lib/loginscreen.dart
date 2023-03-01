import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memgeo/memgeoTheme.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();

  void _loginWithEmailAndPassword() async {
    try {
      if (_email.isNotEmpty && _password.isNotEmpty) {
        // perform login or sign up

        final user = await _auth.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _loginAnonymously() async {
    try {
      final user = await _auth.signInAnonymously();
      if (user != null) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mgSwatch,
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.all(16.0) + EdgeInsets.fromLTRB(0, 32, 0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  style: TextStyle(color: mgSwatch2),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: mgSwatch2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  style: TextStyle(color: mgSwatch2),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: mgSwatch2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Login with email and password
                    }
                  },
                  child: Text('Sign in with Email'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: _loginAnonymously,
                  icon: Icon(Icons.person),
                  label: Text('Sign in Anonymously'),
                ),
                SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Image.asset(
                    'assets/biglogo.png',
                    width: 150.0, // Adjust the width and height as needed
                    height: 150.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
