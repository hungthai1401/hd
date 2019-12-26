import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hd/screens/account/account_page.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  SharedPreferences _prefs;

  void _logout(BuildContext context) async {
    _prefs = await _getSharedPreferences();
    await _prefs.remove('token');
    await _prefs.remove('id');
    await _prefs.remove('username');
    await _prefs.remove('address');
    await _prefs.remove('phone');
    Navigator.of(context).pushReplacementNamed(LoginPage.name);
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: _getSharedPreferences(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              String userName = '';
              String fullName = '';
              if (snapshot.hasData) {
                userName = snapshot.data.getString('username');
                fullName = snapshot.data.getString('fullname');
              }
              return UserAccountsDrawerHeader(
                accountEmail: Text(userName ?? ''),
                accountName: Text(fullName ?? ''),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.home),
            title: Text(FlutterI18n.translate(context, 'title.home')),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(HomePage.name),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.user),
            title: Text(FlutterI18n.translate(context, 'title.account')),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AccountPage.name),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text(FlutterI18n.translate(context, 'btn.logout')),
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(FlutterI18n.translate(context, 'dialog.logout')),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(FlutterI18n.translate(context, 'btn.no')
                          .toUpperCase()),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text(FlutterI18n.translate(context, 'btn.yes')
                          .toUpperCase()),
                      onPressed: () => _logout(context),
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
