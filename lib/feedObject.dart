import 'package:flutter/material.dart';
import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/models/post.dart';

class FeedObject extends StatelessWidget {
  final String title;
  final String text;
  final String coordinates;
  final String datetime;
  final String audioUrl;
  final VoidCallback onTap;

  FeedObject(
      {required this.title,
      required this.text,
      required this.coordinates,
      required this.datetime,
      required this.audioUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        subtitle: Text(text),
      ),
    );
  }
}

class FeedObjectDetails extends StatefulWidget {
  final String uid;
  final String title;
  final String coordinates;
  final String datetime;
  final String sublocality;
  final String audioUrl;
  final String image;
  final int likes;
  final int played;
  final String user;
  final String wall;

  FeedObjectDetails(
      {required this.uid,
      required this.title,
      required this.coordinates,
      required this.datetime,
      required this.audioUrl,
      required this.image,
      required this.likes,
      required this.played,
      required this.user,
      required this.wall,
      required this.sublocality});

  @override
  _FeedObjectDetailsState createState() =>
      _FeedObjectDetailsState(uid, sublocality,
          title: title,
          coordinates: coordinates,
          datetime: datetime,
          audioUrl: audioUrl,
          image: image,
          likes: likes,
          played: played,
          user: user,
          wall: wall);
}

class _FeedObjectDetailsState extends State<FeedObjectDetails> {
  late AudioPlayer _audioPlayer;
  final String uid;
  final String title;
  final String coordinates;
  final String datetime;
  final String sublocality;
  final String audioUrl;
  final String image;
  final int likes;
  final int played;
  final String user;
  final String wall;
  bool _isPlaying = true;

  _FeedObjectDetailsState(this.uid, this.sublocality,
      {required this.title,
      required this.coordinates,
      required this.datetime,
      required this.audioUrl,
      required this.image,
      required this.likes,
      required this.played,
      required this.user,
      required this.wall});

  @override
  void initState() {
    super.initState();
    // create an audio player that can play audio from a url
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(UrlSource(audioUrl));
  }

  // add build method
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _audioPlayer.stop();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Column(
            children: [
              Text(wall),
              Text(coordinates),
              Text(datetime.toString()),
              Text(audioUrl),
              ElevatedButton(
                onPressed: () {
                  if (_isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    //play the audioUrl from url
                    _audioPlayer.play(UrlSource(audioUrl));
                  }
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Text(_isPlaying ? 'Pause' : 'Play'),
              ),
            ],
          ),
        ));
  }
}

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<FeedObject> feedObjects = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    //fetchData
  }

  Future<void> fetchData() async {
    final db = Db();
    List<PostObject> data = await db.retrievePosts();
    _updateFeedObjects2(data);
  }

  //update feedobjects using postobjects
  void _updateFeedObjects2(List<PostObject> data) {
    setState(() {
      feedObjects = data
          .map((feedObjectData) => FeedObject(
                title: feedObjectData.title,
                text: feedObjectData.wall,
                coordinates: feedObjectData.coordinates,
                datetime: feedObjectData.datetime,
                audioUrl: feedObjectData.audioUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedObjectDetails(
                        uid: feedObjectData.uid,
                        sublocality: feedObjectData.sublocality,
                        title: feedObjectData.title,
                        wall: feedObjectData.wall,
                        coordinates: feedObjectData.sublocality,
                        datetime: feedObjectData.datetime,
                        audioUrl: feedObjectData.audioUrl,
                        image: feedObjectData.image,
                        likes: feedObjectData.likes,
                        played: feedObjectData.played,
                        user: feedObjectData.user,
                      ),
                    ),
                  );
                },
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: feedObjects.length,
          itemBuilder: (BuildContext context, int index) {
            final feedObject = feedObjects[index];
            return feedObject; //FeedObject
          }, //itemBuilder
        )); //ListView.builder
  } //_FeedState

} //Feed
