import 'package:flutter/material.dart';
import 'package:hd/route.dart' as routeDefine;
import 'package:hd/screens/splash/splash_page.dart';
import 'package:hd/theme/theme.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HD',
      theme: applicationTheme(),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      onGenerateRoute: routeDefine.routes,
    );
  }
}
