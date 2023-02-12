import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/db.dart';
import 'db/storage.dart';
import 'models/post.dart';
import 'models/recorder_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:memgeo/models/post.dart';

class ViewPostPage extends StatefulWidget {
  final PostObject post;
  const ViewPostPage({required Key key, required this.post}) : super(key: key);
  @override
  _ViewPostPageState createState() => _ViewPostPageState(post);
}

class _ViewPostPageState extends State<ViewPostPage> {
  File _backgroundImage = File('');
  late AudioPlayer _audioPlayer;
  final PostObject post;

  void _updateBackgroundImage(File image) {
    setState(() {
      _backgroundImage = image;
    });
  }

  @override
  _ViewPostPageState createState() => _ViewPostPageState(this.post);
  _ViewPostPageState(this.post);

  @override
  void initState() {
    super.initState();
    // create an audio player that can play audio from a url
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(UrlSource(audioUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _audioPlayer.stop();
          return true;
        },
        child: Scaffold(
          backgroundColor: generateRandomLightColor(),
          body: Container(
            decoration: BoxDecoration(
              image: _backgroundImage.path == ''
                  ? null
                  : DecorationImage(
                      image: FileImage(_backgroundImage),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Column(
              children: [
                // button to take picture

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _titleController,
                    maxLength: 40,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
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
                    child: TextField(
                      controller: _bodyController,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Text Wall',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: TransparentAppBar(
            titleController: _titleController,
            bodyController: _bodyController,
            onTakePicture: takePicture,
            photoPath: photoPath,
          ),
        ));
  }
}
