import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hd/screens/accessory/components/gallery_photo_view_wrapper.dart';

class CapturedImage extends StatelessWidget {
  final File capturedImage;
  final GestureTapCallback onDeleteCapturedImage;

  CapturedImage(
      {@required this.capturedImage, @required this.onDeleteCapturedImage});

  void _openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          item: FileImage(capturedImage),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 1,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openGallery(context),
      child: Container(
        constraints: BoxConstraints.expand(
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
      ),
    );
  }
}
