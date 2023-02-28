import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memgeo/models/post.dart';
import 'package:memgeo/widgets/postcard.dart';
import 'package:memgeo/db/db.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String _userId;
  List<DocumentSnapshot> favoriteDocs = [];

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    print(_userId);
    final snapshot = await _firestore
        .collection('favorites')
        .where('users', arrayContains: _userId)
        .get();
    print(snapshot);
    if (mounted) {
      setState(() {
        favoriteDocs = snapshot.docs;
      });
    }
  }

  Future<PostCard> _getPostCard(String postId) async {
    print('Getting post card for post ID $postId');
    final db = Db();
    final postObject = await db.retrievePostUid(postId);
    final postCard = PostCard(post: postObject);
    return postCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteDocs.isEmpty
          ? Center(
              child: Text('No favorites yet.'),
            )
          : ListView.builder(
              itemCount: favoriteDocs.length,
              itemBuilder: (context, index) {
                final postId = favoriteDocs[index].id;
                return FutureBuilder<PostCard>(
                  future: _getPostCard(postId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
