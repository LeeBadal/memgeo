import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

enum PlaybackState { play, pause, resume }

class RecorderProvider with ChangeNotifier {
  PlaybackState _playbackState = PlaybackState.play;
  final FlutterSoundRecorder _flutterSoundRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isRecording = false;
  String _hasPath = "";
  bool _hasRecording = false;
  late StreamSubscription<PlaybackDisposition> _onPlayerCompletionSubscription;

  PlaybackState get playbackState => _playbackState;
  String get hasPath => _hasPath;
  bool get isRecording => _isRecording;
  bool get hasRecording => _hasRecording;
  FlutterSoundPlayer get audioPlayer => _audioPlayer;
  StreamSubscription<PlaybackDisposition> get onPlayerCompletionSubscription =>
      _onPlayerCompletionSubscription;

  Future<void> startRecording() async {
    if (_isRecording) {
      return;
    }
    await _flutterSoundRecorder.openRecorder();
    await _flutterSoundRecorder.startRecorder(
      toFile: "test",
    );
    _isRecording = true;
    notifyListeners();
    print("Recording started");
  }

  Future<void> stopRecording() async {
    String? recordingPath;
    recordingPath = await _flutterSoundRecorder.stopRecorder();
    await _flutterSoundRecorder.closeRecorder();
    _isRecording = false;
    recordingPath != null ? _hasPath = recordingPath : _hasPath = "";
    notifyListeners();
    print("Recording stopped");
  }

  Future<void> playRecentRecording() async {
    await _audioPlayer.openPlayer();
    await _audioPlayer.startPlayer(
      fromURI: _hasPath,
      // codec: Codec.aacADTS,
    );
    _playbackState = PlaybackState.pause;
    notifyListeners();
  }

  Future<void> pauseRecentRecording() async {
    if (_audioPlayer.playerState.toString() == "PlayerState.isStopped") {
      await playRecentRecording();
    } else {
      await _audioPlayer.pausePlayer();
      print("hello2" + _audioPlayer.playerState.toString());
      _playbackState = PlaybackState.resume;
      notifyListeners();
    }
  }

  Future<void> resumeRecentRecording() async {
    if (_audioPlayer.playerState.toString() == "PlayerState.isStopped") {
      await playRecentRecording();
    } else {
      await _audioPlayer.resumePlayer();
      _playbackState = PlaybackState.pause;
      notifyListeners();
    }
  }

  void setHasRecording(bool value) {
    _hasRecording = value;
    notifyListeners();
  }

  void startListeningToPlayerCompletion() {
    //check if player is initialized

    _onPlayerCompletionSubscription =
        _audioPlayer.dispositionStream()!.listen((event) {
      if (event.duration.inMilliseconds == event.position.inMilliseconds) {
        print("end of audio");
        _audioPlayer.closePlayer();
        _playbackState = PlaybackState.play;
        notifyListeners();
      }
    });
  }
}