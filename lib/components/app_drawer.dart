import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/home_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text('hunghthai1401.it@gmail.com'),
            accountName: Text('Nguyễn Hưng Thái'),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.home),
            title: Text('Home'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(HomePage.name),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.user),
            title: Text('Account'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text('Sign Out'),
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('no'.toUpperCase()),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text('yes'.toUpperCase()),
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(LoginPage.name),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
