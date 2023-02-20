import 'package:flutter/material.dart';
import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:memgeo/memgeoTheme.dart';
import 'package:memgeo/viewPostPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/models/post.dart';
import 'package:memgeo/models/likes.dart';

class FeedObject extends StatefulWidget {
  final String title;
  final String text;
  final String coordinates;
  final String datetime;
  final String audioUrl;
  final VoidCallback onTap;
  final String uid;

  FeedObject({
    required this.uid,
    required this.title,
    required this.text,
    required this.coordinates,
    required this.datetime,
    required this.audioUrl,
    required this.onTap,
  });

  @override
  _FeedObjectState createState() => _FeedObjectState();
}

class _FeedObjectState extends State<FeedObject> {
  late Likes likes = Likes(widget.uid);
  late Future<bool> _isLikedFuture;

  @override
  void initState() {
    super.initState();
    _loadIsLiked();
  }

  void _loadIsLiked() {
    _isLikedFuture = likes.hasLiked();
  }

  void _toggleLike() async {
    bool isLiked = await likes.hasLiked();
    if (isLiked) {
      await likes.toggleLike();
      setState(() {
        _isLikedFuture = likes.hasLiked();
      });
    } else {
      await likes.toggleLike();
      setState(() {
        _isLikedFuture = likes.hasLiked();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        child: ListTile(
          tileColor: mgSwatch[100],
          title: Text(widget.title),
          subtitle: Row(
            children: [
              Expanded(child: Container()),
              FutureBuilder<bool>(
                future: _isLikedFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: mgSwatch2,
                      ),
                      onPressed: _toggleLike,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: _toggleLike,
                    );
                  }
                },
              ),
              FutureBuilder<int>(
                future: likes.getLikesCount(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
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
    return Container();
  }
}

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<FeedObject> feedObjects = [];
  final int _pageSize = 10;
  int _currentPage = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    //fetchData
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() {
      _currentPage++;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('your-collection')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .offset(_currentPage * _pageSize)
          .get();
      final feedObjects =
          querySnapshot.docs.map((doc) => FeedObject(doc)).toList();
      setState(() {
        this.feedObjects.addAll(feedObjects);
      });
    } catch (e) {
      print(e);
    }
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
          .map(
            (feedObjectData) => FeedObject(
              uid: feedObjectData.uid,
              title: feedObjectData.title,
              text: feedObjectData.wall,
              coordinates: feedObjectData.coordinates,
              datetime: feedObjectData.datetime,
              audioUrl: feedObjectData.audioUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPostPage(post: feedObjectData),
                  ),
                );
              },
            ),
          )
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
