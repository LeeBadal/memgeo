import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/post.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewPostPage extends StatefulWidget {
  final PostObject post;
  const ViewPostPage({Key? key, required this.post}) : super(key: key);
  @override
  _ViewPostPageState createState() => _ViewPostPageState(post);
}

class _ViewPostPageState extends State<ViewPostPage> {
  late Future<NetworkImage> _backgroundImage;
  late AudioPlayer _audioPlayer;
  final PostObject post;
  bool _isPlaying = true;

  @override
  _ViewPostPageState createState() => _ViewPostPageState(this.post);
  _ViewPostPageState(this.post);

  @override
  void initState() {
    super.initState();
    // create an audio player that can play audio from a url
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(UrlSource(post.audioUrl));
  }

  Future<void> reportPost() async {
    final user = FirebaseAuth.instance.currentUser!;
    final reportsRef = FirebaseFirestore.instance.collection('reports');
    final reportDoc = reportsRef.doc();

    await reportDoc.set({
      'userId': user.uid,
      'postId': post.uid,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _audioPlayer.stop();
          return true;
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(post.image).image,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // button to take picture
                Padding(
                  padding: const EdgeInsets.all(8.0) + EdgeInsets.only(top: 40),
                  child: Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                  margin: EdgeInsets.only(left: 8, right: 8),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.wall,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  "${post.sublocality}",
                ),

                Text(
                  "${pformat(post.datetime)}",
                ),

                IconButton(
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      //play the audioUrl from url
                      _audioPlayer.play(UrlSource(post.audioUrl));
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.report),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Report Post'),
                          content: TextField(
                            decoration:
                                InputDecoration(hintText: 'Reason for report'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Add flag to post in database
                                // Close dialog
                                reportPost();
                                Navigator.of(context).pop();
                              },
                              child: Text('Submit'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Close dialog without reporting post
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
