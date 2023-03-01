import 'dart:math';
import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

getFileSize(String filepath, int decimals) async {
  var file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

// get datetime and return as string
String getDatetime() {
  DateTime now = DateTime.now();
  String datetime = now.toString();
  return datetime;
}

// generate a random uid
String generateUid() {
  var rng = Random();
  String uid = "";
  for (var i = 0; i < 10; i++) {
    uid += rng.nextInt(10).toString();
  }
  return uid;

  // random background color
}

// random colour but not dark

Color generateRandomLightColor() {
  int red = Random().nextInt(128) + 128;
  int green = Random().nextInt(128) + 128;
  int blue = Random().nextInt(128) + 128;
  return Color.fromARGB(255, red, green, blue);
}

// remove milli seconds from datetime string
String pformat(String datetime) {
  DateTime dt = DateTime.parse(datetime);

  return DateFormat('EEEE, MMMM d, yyyy, HH:mm').format(dt);
}

//convert coordinates string to latlang
LatLng string2latlng(String coordinates) {
  List<String> list = coordinates.split(",");
  double val1 = double.parse(list[0]);
  double val2 = double.parse(list[1]);
  return LatLng(val1, val2);
}
