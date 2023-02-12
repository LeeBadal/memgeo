import 'package:flutter/material.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:memgeo/db/storage.dart';
import 'package:memgeo/postpage.dart';

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
        icon: const Icon(Icons.logout),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sign Out'),
                content: Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      IconButton(
          icon: const Icon(Icons.cloud_upload),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(),
              ),
            );
          })
    ]);
  }
}
