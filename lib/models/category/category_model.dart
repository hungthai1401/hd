import 'package:flutter/cupertino.dart';

class CategoryModel {
  final int id;
  final String name;
  final String image;

  CategoryModel({@required this.id, @required this.name, @required this.image});

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];
}
