import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class RecorderProvider with ChangeNotifier {
  final FlutterSoundRecorder _flutterSoundRecorder = FlutterSoundRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<void> startRecording() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status != PermissionStatus.granted) {
      await Permission.microphone.request();
    }
    status = await Permission.storage.status;
    if (status != PermissionStatus.granted) await Permission.storage.request();
    await _flutterSoundRecorder.openRecorder();
    await _flutterSoundRecorder.startRecorder(
      toFile: "test",
    );
    _isRecording = true;
    notifyListeners();
    print("Recording started");
  }

  Future<void> stopRecording() async {
    dynamic what = await _flutterSoundRecorder.stopRecorder();
    await _flutterSoundRecorder.closeRecorder();
    print(what);
    _isRecording = false;
    notifyListeners();
    print("Recording stopped");
    // play the recording that was just made
    FlutterSoundPlayer? audioPlayer = FlutterSoundPlayer();
    await audioPlayer.openPlayer();
    await audioPlayer.startPlayer(
      fromURI: what,
      // codec: Codec.aacADTS,
    );
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permission = await Permission.storage.request();
      if (permission == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future requestMicrophonePermission() async {
    print('In Microphone permission method');
    //WidgetsFlutterBinding.ensureInitialized();

    await Permission.microphone.request();
  }
}
