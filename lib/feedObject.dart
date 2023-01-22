import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:audioplayers/audioplayers.dart';

class FeedObject extends StatelessWidget {
  final String title;
  final String text;
  final String coordinates;
  final DateTime datetime;
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
  final String title;
  final String text;
  final String coordinates;
  final DateTime datetime;
  final String audioUrl;

  FeedObjectDetails(
      {required this.title,
      required this.text,
      required this.coordinates,
      required this.datetime,
      required this.audioUrl});

  @override
  _FeedObjectDetailsState createState() => _FeedObjectDetailsState(
      title: title,
      text: text,
      coordinates: coordinates,
      datetime: datetime,
      audioUrl: audioUrl);
}

class _FeedObjectDetailsState extends State<FeedObjectDetails> {
  late AudioPlayer _audioPlayer;
  final String title;
  final String text;
  final String coordinates;
  final DateTime datetime;
  final String audioUrl;
  bool _isPlaying = true;

  _FeedObjectDetailsState(
      {required this.title,
      required this.text,
      required this.coordinates,
      required this.datetime,
      required this.audioUrl});

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
              Text(text),
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
    fakefetchData();
    //fetchData
  }

  Future<void> fakefetchData() async {
    // Simulate a delay to simulate an API call
    await Future.delayed(const Duration(seconds: 2));
    // Create some fake data
    final data = [
      {
        "title": "Feed Object 1",
        "subtitle": "This is the first feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-22",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 2",
        "subtitle": "This is the second feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-23",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 3",
        "subtitle": "This is the third feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-24",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 4",
        "subtitle": "This is the fourth feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-25",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 5",
        "subtitle": "This is the fourth feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-25",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 3",
        "subtitle": "This is the third feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-24",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 4",
        "subtitle": "This is the fourth feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-25",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      },
      {
        "title": "Feed Object 5",
        "subtitle": "This is the fourth feed object",
        "coordinates": "12.34,56.78",
        "datetime": "2023-01-25",
        "audioUrl":
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      }
    ];
    _updateFeedObjects(data);
  }

  void _updateFeedObjects(List<Map<String, dynamic>> data) {
    setState(() {
      feedObjects = data
          .map((feedObjectData) => FeedObject(
                title: feedObjectData['title'],
                text: feedObjectData['subtitle'],
                coordinates: feedObjectData['coordinates'],
                datetime: DateTime.parse(feedObjectData['datetime']),
                audioUrl: feedObjectData['audioUrl'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedObjectDetails(
                        title: feedObjectData['title'],
                        text: feedObjectData['subtitle'],
                        coordinates: feedObjectData['coordinates'],
                        datetime: DateTime.parse(feedObjectData['datetime']),
                        audioUrl: feedObjectData['audioUrl'],
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
        onRefresh: fakefetchData,
        child: ListView.builder(
          itemCount: feedObjects.length,
          itemBuilder: (BuildContext context, int index) {
            final feedObject = feedObjects[index];
            return FeedObject(
              title: feedObject.title,
              text: feedObject.text,
              coordinates: feedObject.coordinates,
              datetime: feedObject.datetime,
              audioUrl: feedObject.audioUrl,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedObjectDetails(
                        title: feedObject.title,
                        text: feedObject.text,
                        coordinates: feedObject.coordinates,
                        datetime: feedObject.datetime,
                        audioUrl: feedObject.audioUrl,
                      ),
                    )); //MaterialPageRoute
              }, //onTap
            ); //FeedObject
          }, //itemBuilder
        )); //ListView.builder
  } //_FeedState

} //Feed
