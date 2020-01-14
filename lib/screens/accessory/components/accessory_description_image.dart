import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/screens/accessory/components/gallery_photo_view_wrapper.dart';

class AccessoryDescriptionImage extends StatelessWidget {
  final AccessoryModel accessory;

  AccessoryDescriptionImage({@required this.accessory})
      : assert(accessory is AccessoryModel);

  void _openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          item: NetworkImage(accessory.imageDescription),
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
    return Flexible(
      child: GestureDetector(
        onTap: () => _openGallery(context),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: CachedNetworkImage(
                imageUrl: accessory.imageDescription,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  FontAwesomeIcons.redoAlt,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
