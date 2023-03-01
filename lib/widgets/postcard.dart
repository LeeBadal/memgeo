import 'package:flutter/material.dart';

import '../memgeoTheme.dart';
import '../models/favorite.dart';
import '../models/likes.dart';
import '../models/post.dart';
import '../viewPostPage.dart';

class PostCard extends StatefulWidget {
  final PostObject post;

  PostCard({required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Likes likes = Likes(widget.post.uid);
  late Favorites favorites = Favorites(widget.post.uid);
  late Future<bool> _isLikedFuture;
  late Future<bool> _isFavoritedFuture;

  @override
  void initState() {
    super.initState();
    _loadIsLiked();
    _loadIsFavorited();
  }

  void _loadIsLiked() {
    _isLikedFuture = likes.hasLiked();
  }

  void _loadIsFavorited() {
    _isFavoritedFuture = favorites.hasFav();
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewPostPage(post: widget.post),
          ),
        );
      },
      child: Card(
        child: ListTile(
          tileColor: mgSwatch[100],
          title: Text(widget.post.title),
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
                      icon: Icon(Icons.thumb_up_alt_outlined),
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
