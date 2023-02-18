import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Likes {
  final String postId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Likes(this.postId);

  // Returns the number of likes for the post with the given ID
  Future<int> getLikesCount() async {
    final docSnapshot = await _firestore.collection('likes').doc(postId).get();
    return docSnapshot.data()?['count'] ?? 0;
  }

  // Returns true if the current user has liked the post, false otherwise
  Future<bool> hasLiked() async {
    final user = _auth.currentUser;
    if (user == null) return false; // user not authenticated
    final docSnapshot = await _firestore
        .collection('likes')
        .doc(postId)
        .collection('users')
        .doc(user.uid)
        .get();
    return docSnapshot.exists;
  }

  // Toggles the like status of the current user for the post
  Future<void> toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) return; // user not authenticated
    final batch = _firestore.batch();
    final likeRef = _firestore.collection('likes').doc(postId);
    final userRef = likeRef.collection('users').doc(user.uid);
    final hasLiked = await this.hasLiked();
    if (hasLiked) {
      // Remove the user's like
      batch.set(
        likeRef,
        {'count': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
      batch.delete(userRef);
    } else {
      // Add the user's like
      batch.set(
        likeRef,
        {'count': FieldValue.increment(1)},
        SetOptions(merge: true),
      );
      batch.set(userRef, <String, dynamic>{});
    }
    await batch.commit();
  }
}
