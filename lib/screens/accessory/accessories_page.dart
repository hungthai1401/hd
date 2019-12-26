import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/blocs/accessories_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/screens/accessory/accessory_page.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/sub_category/sub_categories_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessoriesPage extends StatefulWidget {
  static const String name = '/accessories';
  final CategoryModel category;
  final SubCategoryModel subCategory;

  AccessoriesPage(
      {Key key, @required this.subCategory, @required this.category})
      : assert(subCategory is SubCategoryModel),
        assert(category is CategoryModel);

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  final AccessoriesBloc bloc = AccessoriesBloc();
  SubCategoryModel subCategory;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    subCategory = widget.subCategory;
    bloc.fetchAccessories(subCategory);
    bloc.subject.listen((response) async {
      if (response.statusCode == 401 || response.statusCode == 403) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('id');
        await prefs.remove('user_name');
        await prefs.remove('address');
        await prefs.remove('phone');
        Navigator.of(context).pushReplacementNamed(LoginPage.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subCategory.name,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategoriesPage(
                category: widget.category,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<AccessoryResponseModel>(
          stream: bloc.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<AccessoryResponseModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != '') {
                return Text(
                  snapshot.data.error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              }

              List<AccessoryModel> accessories = snapshot.data.results;
              return ListView.separated(
                shrinkWrap: true,
                itemCount: accessories.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final AccessoryModel accessory = accessories[index];
                  return ListTile(
                    title: Text(
                      accessory.name,
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
                        imageUrl: accessory.image,
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
                        builder: (context) => AccessoryPage(
                          category: widget.category,
                          subCategory: subCategory,
                          accessory: accessory,
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
