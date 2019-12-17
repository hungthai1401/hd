import 'package:flutter/material.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/home_page.dart';

PageRoute routes(routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.name:
      return MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      );
    case HomePage.name:
      return MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      );
  }
}
