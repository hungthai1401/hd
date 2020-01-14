import 'package:flutter/cupertino.dart';

class AccessoryModel {
  final int id;
  final String name;
  final String image;
  final String imageDescription;

  AccessoryModel(
      {@required this.id, @required this.name, @required this.image, @required this.imageDescription});

  AccessoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        imageDescription = json['image_des'];
}
