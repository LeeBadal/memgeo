import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';

class RecordingButton extends StatefulWidget {
  RecordingButton({super.key});

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  bool _isRecording = false;
  bool _hasRecording = false;

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    Provider.of<RecorderProvider>(context, listen: false).startRecording();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _hasRecording = true;
    });
    Provider.of<RecorderProvider>(context, listen: false).stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = Provider.of<RecorderProvider>(context);
    return GestureDetector(
      onTapDown: (details) {
        _startRecording();
      },
      onTapUp: (details) {
        _stopRecording();
        recordingState.setHasRecording(true);
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            _isRecording ? "Recording..." : "Recording button",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// a stateful button that says play recording when pressed
// and stops when pressed again
class PlayLocalRecordingButton extends StatefulWidget {
  PlayLocalRecordingButton({super.key});

  @override
  _PlayLocalRecordingButtonState createState() =>
      _PlayLocalRecordingButtonState();
}

class _PlayLocalRecordingButtonState extends State<PlayLocalRecordingButton> {
  PlaybackState playbackState = PlaybackState.play;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playbackState =
        Provider.of<RecorderProvider>(context, listen: true).playbackState;
    return GestureDetector(
      onTap: () {
        if (playbackState == PlaybackState.play) {
          Provider.of<RecorderProvider>(context, listen: false)
              .playRecentRecording();
        } else if (playbackState == PlaybackState.pause) {
          Provider.of<RecorderProvider>(context, listen: false)
              .pauseRecentRecording();
        } else if (playbackState == PlaybackState.resume) {
          Provider.of<RecorderProvider>(context, listen: false)
              .resumeRecentRecording();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            playbackState == PlaybackState.play
                ? "Play recording"
                : playbackState == PlaybackState.pause
                    ? "Pause"
                    : "Resume",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
