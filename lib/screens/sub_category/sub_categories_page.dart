import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/blocs/sub_category_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/models/sub_category/sub_category_response_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoriesPage extends StatefulWidget {
  static const String name = '/accessories';
  final CategoryModel category;

  SubCategoriesPage({Key key, @required this.category})
      : assert(category is CategoryModel);

  @override
  _SubCategoriesPageState createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  final SubCategoryBloc bloc = SubCategoryBloc();
  CategoryModel category;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    category = widget.category;
    bloc.fetchSubCategories(category);
    bloc.subject.listen((response) async {
      if (response.statusCode == 401 || response.statusCode == 403) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('id');
        await prefs.remove('username');
        await prefs.remove('fullname');
        await prefs.remove('address');
        await prefs.remove('phone');
        await prefs.remove('show-account');
        Navigator.of(context).pushReplacementNamed(LoginPage.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(HomePage.name),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<SubCategoryResponse>(
          stream: bloc.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<SubCategoryResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != '') {
                return Text(
                  snapshot.data.error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              }

              List<SubCategoryModel> subCategories = snapshot.data.results;
              return ListView.separated(
                shrinkWrap: true,
                itemCount: subCategories.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final SubCategoryModel subCategory = subCategories[index];
                  return ListTile(
                    title: Text(
                      subCategory.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 80,
                        minHeight: 80,
                        maxWidth: 80,
                        maxHeight: 80,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: subCategory.image,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          FontAwesomeIcons.redoAlt,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessoriesPage(
                          category: category,
                          subCategory: subCategory,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Skeleton();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
