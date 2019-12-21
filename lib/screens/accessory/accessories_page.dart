import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hd/blocs/accessories_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/screens/accessory/accessory_page.dart';
import 'package:hd/screens/home/home_page.dart';

class AccessoriesPage extends StatefulWidget {
  static const String name = '/accessories';
  final CategoryModel category;

  AccessoriesPage({Key key, @required this.category})
      : assert(category is CategoryModel);

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  final AccessoriesBloc bloc = AccessoriesBloc();
  CategoryModel category;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    category = widget.category;
    bloc.fetchAccessories(category);
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
        child: StreamBuilder<AccessoryResponseModel>(
          stream: bloc.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<AccessoryResponseModel> snapshot) {
            if (snapshot.hasData) {
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
                      child: Image.network(
                        accessory.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessoryPage(
                          category: category,
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
