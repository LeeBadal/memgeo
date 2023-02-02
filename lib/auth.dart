import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  //anonymous sign in
  Future<UserCredential> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          throw (e);
        default:
          print("Unknown error.");
          throw (e);
      }
    }
  }

  // get current user
  User? get user => _auth.currentUser;
  //get current user id
  String? get userId => _auth.currentUser?.uid;
  //check signed in
  bool get isSignedIn => _auth.currentUser != null;
}
