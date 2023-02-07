import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/db.dart';
import 'db/storage.dart';
import 'models/post.dart';
import 'models/recorder_model.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, Random().nextInt(256),
          Random().nextInt(256), Random().nextInt(256)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              maxLength: 40,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 1,
            margin: EdgeInsets.only(left: 8, right: 8),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Text Wall',
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: TransparentAppBar(
        titleController: _titleController,
        bodyController: _bodyController,
      ),
    );
  }
}

class TransparentAppBar extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;

  TransparentAppBar({
    Key? key,
    required this.titleController,
    required this.bodyController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu),
          Icon(Icons.search),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (Provider.of<RecorderProvider>(context, listen: false)
                  .hasRecording) {
                try {
                  final filename =
                      Provider.of<RecorderProvider>(context, listen: false)
                          .filename;
                  final path =
                      Provider.of<RecorderProvider>(context, listen: false)
                          .hasPath;
                  final storage = Storage();
                  final url = await storage.uploadAudio(filename, path);
                  print(url);
                  final po = await PostObject.create(
                    titleController.text,
                    url,
                    "abc",
                    FirebaseAuth.instance.currentUser!.uid,
                    bodyController.text,
                  );
                  final db = Db();
                  db.addPostObject(po);
                } catch (e) {
                  print(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
