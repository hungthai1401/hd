import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/blocs/category_bloc.dart';
import 'package:hd/components/app_drawer.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/category/category_response_model.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/components/category_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String name = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryBloc bloc = CategoryBloc();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    bloc.fetchCategories();
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
          FlutterI18n.translate(context, 'title.home'),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<CategoryResponseModel>(
          stream: bloc.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<CategoryResponseModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != '') {
                return Text(
                  snapshot.data.error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              }

              List<CategoryModel> categories = snapshot.data.results;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                    child: CategoryCard(
                      category: categories[index],
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bloc.dispose();
    super.dispose();
  }
}
