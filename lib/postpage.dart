import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memgeo/memgeoTheme.dart';
import 'package:provider/provider.dart';

import 'db/db.dart';
import 'db/storage.dart';
import 'models/post.dart';
import 'models/recorder_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:memgeo/widgets/successDialog.dart';
import 'package:memgeo/recordingButton.dart' as recordingButton;

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  File _backgroundImage = File('');
  String photoPath = '';

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
      photoPath = photo.path;
      _updateBackgroundImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = Provider.of<RecorderProvider>(context);
    return Scaffold(
      backgroundColor: mgSwatch,
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
              padding: const EdgeInsets.all(8.0) + EdgeInsets.only(top: 40),
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
            Positioned(
                bottom: 0,
                child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        recordingButton.RecordingButton(),
                        recordingState.hasRecording
                            ? recordingButton.PlayLocalRecordingButton()
                            : Container()
                      ],
                    )))
          ],
        ),
      ),
      bottomNavigationBar: TransparentAppBar(
        titleController: _titleController,
        bodyController: _bodyController,
        onTakePicture: takePicture,
        photoPath: photoPath,
      ),
    );
  }
}

class TransparentAppBar extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final VoidCallback onTakePicture;
  bool imageExist = false;
  String photoPath = '';
  String imageUrl = '';

  void imageExistsSwitch() {
    imageExist = !imageExist;
  }

  TransparentAppBar({
    Key? key,
    required this.titleController,
    required this.bodyController,
    required this.onTakePicture,
    required this.photoPath,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                onTakePicture();
              }),
          IconButton(
              icon: Icon(Icons.save),
              splashColor: Colors.black,
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you want to upload this post?'),
                      actions: [
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            int counter = 0;
                            Navigator.popUntil(context, (route) {
                              return counter++ == 2;
                            });
                            if (Provider.of<RecorderProvider>(context,
                                    listen: false)
                                .hasRecording) {
                              try {
                                final filename = Provider.of<RecorderProvider>(
                                        context,
                                        listen: false)
                                    .filename;
                                final path = Provider.of<RecorderProvider>(
                                        context,
                                        listen: false)
                                    .hasPath;
                                final storage = Storage();
                                final url =
                                    await storage.uploadAudio(filename, path);
                                if (photoPath != '') {
                                  imageUrl =
                                      await storage.uploadImage(photoPath);
                                }
                                final po = await PostObject.create(
                                  titleController.text,
                                  url,
                                  imageUrl,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  bodyController.text,
                                );
                                final db = Db();
                                db.addPostObject(po);
                              } catch (e) {
                                failedDialog(context,
                                    message:
                                        "There was an error, please try again");
                                print(e);
                              }
                            }
                          },
                        ),
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ]));
  }
}
