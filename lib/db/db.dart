import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memgeo/models/post.dart';
// import firestore
// import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addPostObject(PostObject post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  Future<List<PostObject>> retrievePosts() async {
    final ref = _firestore.collection("posts").withConverter(
          fromFirestore: PostObject.fromFirestore,
          toFirestore: (PostObject po, _) => po.toFirestore(),
        );
    final docSnap = await ref.get();
    final result = docSnap.docs.map((e) => e.data()).toList();
    return result;
  }

  // retrieve x latest posts
  Future<List<PostObject>> retrieveLatestPosts(int x) async {
    final ref = _firestore.collection("posts").withConverter(
          fromFirestore: PostObject.fromFirestore,
          toFirestore: (PostObject po, _) => po.toFirestore(),
        );
    final docSnap = await ref.orderBy('date', descending: true).limit(x).get();
    final result = docSnap.docs.map((e) => e.data()).toList();
    return result;
  }

  // retrieve post by uid
  Future<PostObject> retrievePost(String uid) async {
    final ref = _firestore.collection("posts").withConverter(
          fromFirestore: PostObject.fromFirestore,
          toFirestore: (PostObject po, _) => po.toFirestore(),
        );
    final docSnap = await ref.doc(uid).get();
    final result = docSnap.data();
    return result!;
  }
}
