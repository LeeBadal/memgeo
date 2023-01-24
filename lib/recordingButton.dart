import 'package:flutter/material.dart';
import 'package:memgeo/recording.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';

class RecordingButton extends StatelessWidget {
  RecordingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        Provider.of<RecorderProvider>(context, listen: false).startRecording();
      },
      onTapUp: (details) {
        Provider.of<RecorderProvider>(context, listen: false).stopRecording();
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
            "Recording button",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
