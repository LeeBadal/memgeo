import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

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
      if (user != null) {
        print("YIKES");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) => _email = value,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) => _password = value,
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                onPressed: _loginWithEmailAndPassword,
                child: Text('Sign in with email and password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OutlinedButton.icon(
                icon: Icon(Icons.person_outline),
                label: Text('Sign in anonymously'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: _loginAnonymously,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
