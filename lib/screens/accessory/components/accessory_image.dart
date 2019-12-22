import 'package:flutter/material.dart';
import 'package:hd/models/accessory_image/accessory_image_model.dart';

class AccessoryImage extends StatelessWidget {
  final AccessoryImageModel accessoryImage;

  AccessoryImage({@required this.accessoryImage})
      : assert(accessoryImage is AccessoryImageModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: new BoxConstraints.expand(
          height: 400.0,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(accessoryImage.image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
    ;
  }
}
