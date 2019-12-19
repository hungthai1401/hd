import 'package:flutter/material.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  CategoryCard({@required this.category}) : assert(category is CategoryModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Image.network(
                category.image,
              ),
            ),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccessoriesPage(
            category: category,
          ),
        ),
      ),
    );
  }
}
