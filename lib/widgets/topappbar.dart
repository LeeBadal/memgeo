import 'package:flutter/material.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(actions: [
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
          //sign out
          FirebaseAuth.instance.signOut();
        },
      ),
      IconButton(
        icon: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (Provider.of<RecorderProvider>(context, listen: false)
              .hasRecording) {
            try {
              final po = await PostObject.create(
                "test",
                "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                "abc",
                FirebaseAuth.instance.currentUser!.uid,
                "textwall",
              );
              final db = Db();
              db.addPostObject(po);
            } catch (e) {
              print(e);
            }
          }
        },
      )
    ]);
  }
}
