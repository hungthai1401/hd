import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hd/blocs/category_bloc.dart';
import 'package:hd/components/app_drawer.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/category/category_response_model.dart';
import 'package:hd/screens/home/components/category_card.dart';

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
    bloc.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<CategoryResponseModel>(
          stream: bloc.subject.stream,
          builder: (context, AsyncSnapshot<CategoryResponseModel> snapshot) {
            if (snapshot.hasData) {
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
    super.dispose();
    bloc.dispose();
  }
}
