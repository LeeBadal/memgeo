import 'package:flutter/material.dart';
import 'package:memgeo/feedObject.dart' as feed;
import 'package:memgeo/recordingButton.dart' as recordingButton;
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RecorderProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appbar with three icons that change screen on click
        appBar: AppBar(actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              print('home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              print('settings');
            },
          ),
        ]),
        body: Stack(
          children: [
            const feed.Feed(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: recordingButton.RecordingButton(),
              ),
            ),
          ],
        ));
  }
}
