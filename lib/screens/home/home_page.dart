import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String name = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        crossAxisCount: 2,
        children: new List<Widget>.generate(
          16,
          (index) {
            return new GridTile(
              child: new Card(
                  color: Colors.blue.shade200,
                  child: new Center(
                    child: new Text('tile $index'),
                  )),
            );
          },
        ),
      ),
    );
  }
}
