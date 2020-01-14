import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/screens/sub_category/sub_categories_page.dart';

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
              child: CachedNetworkImage(
                imageUrl: category.image,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  FontAwesomeIcons.redoAlt,
                ),
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
          builder: (context) => SubCategoriesPage(
            category: category,
          ),
        ),
      ),
    );
  }
}
