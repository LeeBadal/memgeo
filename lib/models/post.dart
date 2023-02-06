import 'package:memgeo/location.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostObject {
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

  static Future<PostObject> create(String title, String audioUrl, String image,
      String user, String wall) async {
    String sublocality = await determineSubLocality();
    String coordinates = await determineCoordinates();
    String uid = generateUid();
    String datetime = getDatetime();
    return PostObject(
      uid: uid,
      title: title,
      coordinates: coordinates,
      datetime: datetime,
      sublocality: sublocality,
      audioUrl: audioUrl,
      image: image,
      likes: 0,
      played: 0,
      user: user,
      wall: wall,
    );
  }

  PostObject({
    required this.uid,
    this.title = "",
    this.wall = "",
    this.coordinates = "Unknown",
    required this.datetime,
    this.sublocality = "Unknown",
    required this.audioUrl,
    this.image = "",
    this.likes = 0,
    this.played = 0,
    this.user = "Anonymous",
  });
  factory PostObject.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return PostObject(
        uid: data?['uid'],
        title: data?['title'],
        coordinates: data?['coordinates'],
        datetime: data?['datetime'],
        sublocality: data?['sublocality'],
        audioUrl: data?['audioUrl'],
        image: data?['image'],
        likes: data?['likes'],
        played: data?['played'],
        user: data?['user'],
        wall: data?['wall']);
  }
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'title': title,
      'coordinates': coordinates,
      'datetime': datetime,
      'sublocality': sublocality,
      'audioUrl': audioUrl,
      'image': image,
      'likes': likes,
      'played': played,
      'user': user,
      'wall': wall,
    };
  }
}
