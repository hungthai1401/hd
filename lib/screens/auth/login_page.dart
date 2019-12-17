import 'package:flutter/material.dart';
import 'package:hd/screens/home/home_page.dart';

class LoginPage extends StatefulWidget {
  static const String name = '/auth';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final userName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'username'.toUpperCase(),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'password'.toUpperCase(),
      ),
    );

    final loginButton = RaisedButton(
      onPressed: () =>
          Navigator.of(context).pushReplacementNamed(HomePage.name),
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'login'.toUpperCase(),
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
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            userName,
            SizedBox(
              height: 30.0,
            ),
            password,
            SizedBox(
              height: 30.0,
            ),
            loginButton,
          ],
        ),
      ),
    );
  }
}
