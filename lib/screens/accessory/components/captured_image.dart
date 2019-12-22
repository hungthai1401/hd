import 'dart:io';

import 'package:flutter/material.dart';

class CapturedImage extends StatelessWidget {
  final File capturedImage;
  final GestureTapCallback onDeleteCapturedImage;

  CapturedImage(
      {@required this.capturedImage, @required this.onDeleteCapturedImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: new BoxConstraints.expand(
        height: 400.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(capturedImage).image,
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () => onDeleteCapturedImage(),
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
