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

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('favorites')
            .doc(_userId)
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading favorites.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final favoriteDocs = snapshot.data!.docs;

          if (favoriteDocs.isEmpty) {
            return Center(
              child: Text('No favorites yet.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteDocs.length,
            itemBuilder: (context, index) {
              final postId = favoriteDocs[index].id;
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('posts')
                    .where(FieldPath.documentId,
                        whereIn: favoriteDocs.map((doc) => doc.id).toList())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error loading post.');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return FutureBuilder<PostCard>(
                    future: _getPostCard(postId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
              );
            },
          );
        },
      ),
    );
  }
}
