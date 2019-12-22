import 'package:flutter/material.dart';
import 'package:hd/components/app_drawer.dart';
import 'package:hd/screens/home/home_page.dart';

class AccountPage extends StatefulWidget {
  static const String name = '/profile';

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final Widget _userName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'username'.toUpperCase(),
      ),
    );

    final Widget _password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'password'.toUpperCase(),
      ),
    );

    final Widget _phone = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'phone'.toUpperCase(),
      ),
    );

    final Widget _fullName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'full name'.toUpperCase(),
      ),
    );

    final _saveButton = RaisedButton(
      onPressed: () =>
          Navigator.of(context).pushReplacementNamed(HomePage.name),
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'save'.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            _userName,
            SizedBox(
              height: 30.0,
            ),
            _password,
            SizedBox(
              height: 30.0,
            ),
            _phone,
            SizedBox(
              height: 30.0,
            ),
            _fullName,
            SizedBox(
              height: 30.0,
            ),
            _saveButton,
          ],
        ),
      ),
    );
  }
}
