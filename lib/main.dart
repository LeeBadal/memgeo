import 'package:flutter/material.dart';
import 'package:memgeo/feedObject.dart' as feed;
import 'package:memgeo/recordingButton.dart' as recordingButton;
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:memgeo/permissions.dart';
import 'package:provider/provider.dart';
import 'package:memgeo/location.dart' as geo;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memgeo/loginscreen.dart';

const kDebugMode = true;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Ideal time to initialize
  //if (kDebugMode) {
  // await FirebaseAuth.instance.useAuthEmulator('192.168.0.8', 9099);
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(builder: (context, snapshot) {
            return ChangeNotifierProvider(
                create: (_) => RecorderProvider(),
                child: MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: const MyHomePage(title: 'Flutter Demo Home Page'),
                ));
          });
        } else {
          return MaterialApp(
            home: LoginScreen(),
          );
        }
      },
    );
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
              geo.determineSubLocality().then((value) {
                print(value);
              });
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
              //sign out
              FirebaseAuth.instance.signOut();
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
