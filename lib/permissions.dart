import 'dart:ffi';

import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> recordPermissionRequest() async {
  PermissionStatus status = await Permission.microphone.request();
  if (status == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}
