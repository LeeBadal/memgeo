import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:memgeo/memgeoTheme.dart';
import 'package:memgeo/viewPostPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/models/post.dart';
import 'package:memgeo/models/likes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads/adstate.dart';
import 'models/favorite.dart';

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
  late Favorites favorites = Favorites(widget.uid);
  late Future<bool> _isLikedFuture;
  late Future<bool> _isFavoritedFuture;

  @override
  void initState() {
    super.initState();
    _loadIsLiked();
    _loadIsFavorited();
  }

  void _loadIsFavorited() {
    _isFavoritedFuture = favorites.hasFav();
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

  void _toggleFavorite() async {
    bool isFavorited = await favorites.hasFav();
    if (isFavorited) {
      await favorites.toggleFav();
      setState(() {
        _isFavoritedFuture = favorites.hasFav();
      });
    } else {
      await favorites.toggleFav();
      setState(() {
        _isFavoritedFuture = favorites.hasFav();
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
                future: _isFavoritedFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: _toggleFavorite,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: _toggleFavorite,
                    );
                  }
                },
              ),
              FutureBuilder<bool>(
                future: _isLikedFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: mgSwatch2,
                      ),
                      onPressed: _toggleLike,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.thumb_up_outlined),
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
  List<dynamic> feedObjects = [];
  final int _pageSize = 8;
  static const _kAdIndex = 4;
  bool _isLastPage = false;
  bool _isLoading = false;
  final _scrollController = ScrollController();
  DocumentSnapshot? pag;

  void _onScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading) {
      _loadMore();
      _isLoading = true;
    }
  }

  void _loadMore() async {
    _isLoading = true;
    final db = Db();
    List<dynamic> dataAndQueryDocument =
        await db.retrievePostsPaginate(_pageSize, startAfter: pag);
    pag = dataAndQueryDocument[1] as DocumentSnapshot?;
    if (dataAndQueryDocument[0].length < _pageSize) {
      setState(() => _isLastPage = true);
    }
    _updateFeedObjects2(dataAndQueryDocument[0] as List<PostObject>);
    _isLoading = false;
  }

  Future<void> fetchData() async {
    final db = Db();
    List dataAndQueryDocument =
        await db.retrievePostsPaginate(_pageSize, startAfter: pag);
    pag = dataAndQueryDocument[1] as DocumentSnapshot?;
    if (dataAndQueryDocument[0].length < _pageSize) {
      setState(() => _isLastPage = true);
    }
    _updateFeedObjects2(dataAndQueryDocument[0] as List<PostObject>);
    _isLoading = false;
  }

  //update feedobjects using postobjects
  void _updateFeedObjects2(List<PostObject> data) {
    setState(() {
      int startIndex = feedObjects.length;
      int endIndex = data.length;
      print(startIndex);
      print(endIndex);
      feedObjects.addAll(data
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
          .toList());
      for (int i = startIndex; i < startIndex + endIndex; i++) {
        print(i);
        if (i % _kAdIndex == 0) {
          print("this happened");
          feedObjects.insert(i, BannerAdmob());
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    //fetchData
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);
    return RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: feedObjects.length,
          itemBuilder: (BuildContext context, int index) {
            final feedObject = feedObjects[index];
            return feedObject;
            //FeedObject
          }, //itemBuilder
        )); //ListView.builder
  } //_FeedState

  @override
  void dispose() {
    super.dispose();
  }

  int _getDestinationItemIndex(int rawIndex, int adIndex) {
    if (rawIndex % _kAdIndex != 0 && rawIndex >= _kAdIndex) {
      return rawIndex - adIndex;
    }
    return rawIndex;
  }
} //Feed
