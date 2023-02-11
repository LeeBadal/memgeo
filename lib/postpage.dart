import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/db.dart';
import 'db/storage.dart';
import 'models/post.dart';
import 'models/recorder_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memgeo/randomHelpers.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  File _backgroundImage = File('');

  void _updateBackgroundImage(File image) {
    setState(() {
      _backgroundImage = image;
    });
  }

  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    print(ImageSource.camera);
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final image = (File(photo.path));
      _updateBackgroundImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: generateRandomLightColor(),
      body: Container(
        decoration: BoxDecoration(
          image: _backgroundImage.path == ''
              ? null
              : DecorationImage(
                  image: FileImage(_backgroundImage),
                  fit: BoxFit.cover,
                ),
        ),
        child: Column(
          children: [
            // button to take picture

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                maxLength: 40,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
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
            IconButton(icon: Icon(Icons.camera_alt), onPressed: takePicture),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Text Wall',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TransparentAppBar(
        titleController: _titleController,
        bodyController: _bodyController,
        onTakePicture: takePicture,
      ),
    );
  }
}

class TransparentAppBar extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final VoidCallback onTakePicture;

  TransparentAppBar({
    Key? key,
    required this.titleController,
    required this.bodyController,
    required this.onTakePicture,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: onTakePicture),
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
