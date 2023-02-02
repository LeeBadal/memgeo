import 'dart:math';
import 'dart:io';

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
}
