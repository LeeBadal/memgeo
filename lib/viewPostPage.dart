import 'package:flutter/material.dart';
import 'models/post.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:memgeo/randomHelpers.dart';

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
                  padding: const EdgeInsets.all(8.0),
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

                ElevatedButton(
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
                  child: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ),
        ));
  }
}
