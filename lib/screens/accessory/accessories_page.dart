import 'package:flutter/material.dart';
import 'package:hd/models/category/category_model.dart';

class AccessoriesPage extends StatefulWidget {
  static const String name = '/accessories';
  final CategoryModel category;

  AccessoriesPage({Key key, @required this.category})
      : assert(category is CategoryModel);

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
        ),
      ),
      body: Center(
        child: Text(
          'List accessories',
        ),
      ),
    );
  }
}
