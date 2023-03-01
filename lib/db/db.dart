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
    final docSnap =
        await ref.orderBy('datetime', descending: true).limit(x).get();
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

  Future<List<dynamic>> retrievePostsPaginate(int page,
      {DocumentSnapshot? startAfter}) async {
    final ref = _firestore
        .collection("posts")
        .orderBy('datetime', descending: true)
        .withConverter(
          fromFirestore: PostObject.fromFirestore,
          toFirestore: (PostObject po, _) => po.toFirestore(),
        )
        .limit(page);

    if (startAfter != null) {
      final startAfterRef = ref.startAfterDocument(startAfter);
      final querySnapshot = await startAfterRef.get();
      final lastDoc =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      final posts = querySnapshot.docs.map((doc) => doc.data()).toList();
      return [posts, lastDoc];
    } else {
      final querySnapshot = await ref.get();
      final lastDoc =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      final posts = querySnapshot.docs.map((doc) => doc.data()).toList();
      return [posts, lastDoc];
    }
  }

  Future<PostObject> retrievePostUid(String uid) async {
    final ref = _firestore.collection("posts").withConverter(
          fromFirestore: PostObject.fromFirestore,
          toFirestore: (PostObject po, _) => po.toFirestore(),
        );
    final querySnapshot = await ref.where('uid', isEqualTo: uid).limit(1).get();
    final result = querySnapshot.docs.first.data();
    return result!;
  }
}
