import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/blocs/accessories_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/screens/accessory/accessory_page.dart';
import 'package:hd/screens/auth/login_page.dart';
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
    bloc.fetchAccessories(subCategory, '');
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

  void onSearch(String keyword) {
    bloc.fetchAccessories(subCategory, keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subCategory.name,
        ),
      ),
      body: SafeArea(
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
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: onSearch,
                        decoration: InputDecoration(
                          labelText: FlutterI18n.translate(context, 'search'),
                          hintText: FlutterI18n.translate(context, 'search'),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: accessories.length,
                        cacheExtent: double.infinity,
                        physics: const AlwaysScrollableScrollPhysics(),
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
                      ),
                    ),
                  ],
                ),
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
