// firebase cloud storage,
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memgeo/models/post.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'dart:io';

class Storage {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadAudio(String filename, String path) async {
    final ref = _storage.ref().child("recordings/${filename}");
    final uploadTask = ref.putFile(File(path));
    final snapshot = await uploadTask;
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  // upload image to firebase storage
  Future<String> uploadImage(String filename, String path) async {
    final ref = _storage.ref().child("images/${filename}");
    final uploadTask = ref.putFile(File(path));
    final snapshot = await uploadTask;
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
