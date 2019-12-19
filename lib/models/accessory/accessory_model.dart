import 'package:flutter/cupertino.dart';

class AccessoryModel {
  final int id;
  final String name;
  final String image;

  AccessoryModel(
      {@required this.id, @required this.name, @required this.image});

  AccessoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];
}
