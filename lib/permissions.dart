import 'dart:ffi';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> recordPermissionsRequest() async {
  PermissionStatus status1 = await Permission.microphone.status;
  PermissionStatus status2 = await Permission.storage.status;
  PermissionStatus status3 = await Permission.location.status;
  if (status1 != PermissionStatus.granted ||
      status2 != PermissionStatus.granted ||
      status3 != PermissionStatus.granted) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.microphone,
    ].request();
    if (statuses[Permission.location] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted) {
      return false;
    } else {
      return true;
    }
  }

  return true;
}
