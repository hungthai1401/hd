import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CameraPlaceHolderImage extends StatelessWidget {
  final GestureTapCallback onCapture;

  CameraPlaceHolderImage({@required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                'https://www.keh.com/skin/frontend/keh/default/images/placeholder-min.png',
            placeholder: (context, url) => const Center(
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(
              FontAwesomeIcons.redoAlt,
            ),
          ),
        ],
      ),
      onTap: () => onCapture(),
    );
  }
}
