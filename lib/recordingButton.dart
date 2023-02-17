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

class _RecordingButtonState extends State<RecordingButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRecording = false;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _animationController.forward(from: 0.0);
    });
    Provider.of<RecorderProvider>(context, listen: false).startRecording();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      Provider.of<RecorderProvider>(context, listen: false).hasRecording = true;
      _animationController.stop();
    });
    Provider.of<RecorderProvider>(context, listen: false).stopRecording();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _startRecording();
      },
      onTapUp: (details) {
        _stopRecording();
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _animationController.value,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                      strokeWidth: 5,
                    );
                  },
                ),
              ),
            ),
          ],
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
    return IconButton(
      onPressed: () {
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
      icon: Icon(
        playbackState == PlaybackState.play
            ? Icons.replay
            : playbackState == PlaybackState.pause
                ? Icons.pause
                : Icons.play_arrow,
      ),
    );
  }
}
