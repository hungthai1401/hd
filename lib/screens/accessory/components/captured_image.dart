import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hd/screens/accessory/components/gallery_photo_view_wrapper.dart';

class CapturedImage extends StatelessWidget {
  final File capturedImage;

  CapturedImage({@required this.capturedImage});

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
      child: Column(
        children: <Widget>[
          Image.file(capturedImage),
        ],
      ),
    );
  }
}
