import 'package:flutter/material.dart';

class AccessoryImageModel {
  final String image;

  AccessoryImageModel({@required this.image});

  AccessoryImageModel.fromJson(String json) : image = json;
}
