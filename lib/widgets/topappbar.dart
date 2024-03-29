import 'package:flutter/material.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/favouriteScreen.dart';
import 'package:memgeo/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memgeo/models/recorder_model.dart';
import 'package:provider/provider.dart';
import 'package:memgeo/db/storage.dart';
import 'package:memgeo/postpage.dart';
import 'package:memgeo/mapscreen.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(),
                ),
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
              }),
          IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              })
        ]);
  }
}
