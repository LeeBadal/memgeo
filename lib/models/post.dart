import 'package:memgeo/location.dart';
import 'package:memgeo/randomHelpers.dart';

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

  static Future<PostObject> create(
      String title, String audioUrl, String image, String user) async {
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
        user: user);
  }

  PostObject({
    required this.uid,
    this.title = '',
    this.coordinates = "Unknown",
    required this.datetime,
    this.sublocality = "Unknown",
    required this.audioUrl,
    this.image = "",
    this.likes = 0,
    this.played = 0,
    this.user = "Anonymous",
  });
}
