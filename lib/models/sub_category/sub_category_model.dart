import 'package:flutter/cupertino.dart';

class SubCategoryModel {
  final int id;
  final String name;
  final String image;
  final int type;

  SubCategoryModel(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.type})
      : assert(id != null),
        assert(name != null),
        assert(image != null),
        assert(type != null);

  SubCategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        type = json['type'];
}
