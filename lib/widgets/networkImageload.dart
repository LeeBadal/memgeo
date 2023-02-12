import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageWithLoadingIndicator extends StatefulWidget {
  final String imageUrl;

  ImageWithLoadingIndicator({required this.imageUrl});

  @override
  State<ImageWithLoadingIndicator> createState() =>
      _ImageWithLoadingIndicatorState();
}

class _ImageWithLoadingIndicatorState extends State<ImageWithLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: CircularProgressIndicator()),
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
