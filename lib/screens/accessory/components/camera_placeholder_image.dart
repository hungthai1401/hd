import 'package:flutter/material.dart';

class CameraPlaceHolderImage extends StatelessWidget {
  final GestureTapCallback onCapture;

  CameraPlaceHolderImage({@required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        constraints: BoxConstraints.expand(
          height: 400.0,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.keh.com/skin/frontend/keh/default/images/placeholder-min.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      onTap: () => onCapture(),
    );
  }
}
