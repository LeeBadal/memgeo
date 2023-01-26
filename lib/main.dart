import 'package:flutter/material.dart';
import 'package:memgeo/feedObject.dart' as feed;
import 'package:memgeo/recordingButton.dart' as recordingButton;
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:memgeo/permissions.dart';
import 'package:provider/provider.dart';

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
  bool _hasRecording = false;
  @override
  void initState() {
    super.initState();
    recordPermissionsRequest().then((value) {
      if (value) {
        print('Permissions granted');
      } else {
        print('Permissions not granted');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = Provider.of<RecorderProvider>(context);
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
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: recordingButton.RecordingButton(),
                        ),
                        recordingState.hasRecording
                            ? Expanded(
                                child:
                                    recordingButton.PlayLocalRecordingButton(),
                              )
                            : Expanded(child: Container())
                      ],
                    ))),
          ],
        ));
  }
}
