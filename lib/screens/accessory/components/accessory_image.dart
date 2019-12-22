import 'package:flutter/material.dart';
import 'package:hd/models/accessory_image/accessory_image_model.dart';
import 'package:hd/screens/accessory/components/gallery_photo_view_wrapper.dart';

class AccessoryImage extends StatelessWidget {
  final AccessoryImageModel accessoryImage;

  AccessoryImage({@required this.accessoryImage})
      : assert(accessoryImage is AccessoryImageModel);

  void _openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          item: NetworkImage(accessoryImage.image),
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
    return Expanded(
      child: GestureDetector(
        onTap: () => _openGallery(context),
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
      ),
    );
  }
}
