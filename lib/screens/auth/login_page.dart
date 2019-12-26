import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/blocs/auth_bloc.dart';
import 'package:hd/screens/home/home_page.dart';

class LoginPage extends StatefulWidget {
  static const String name = '/auth';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    bloc.authenticate.listen((state) {
      if (state) {
        Navigator.of(context).pushReplacementNamed(HomePage.name);
      }
    });
  }

  Widget _userName(AuthBloc bloc) => StreamBuilder<String>(
        stream: bloc.userName,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              hintText:
                  FlutterI18n.translate(context, 'username').toUpperCase(),
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeUserName,
          );
        },
      );

  Widget _password(AuthBloc bloc) => StreamBuilder<String>(
        stream: bloc.password,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText:
                  FlutterI18n.translate(context, 'password').toUpperCase(),
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          );
        },
      );

  Widget _loginButton(AuthBloc bloc) => StreamBuilder<bool>(
        stream: bloc.submitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return RaisedButton(
            onPressed: () => snapshot.hasData ? bloc.attempt(context) : null,
            color: Colors.redAccent,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                FlutterI18n.translate(context, 'btn.login').toUpperCase(),
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
        },
      );

  Widget _alert(AuthBloc bloc) => StreamBuilder<bool>(
        stream: bloc.authenticate,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Visibility(
            visible: snapshot.hasError,
            child: Text(
              snapshot.error ?? '',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _alert(bloc),
            SizedBox(
              height: 30.0,
            ),
            _userName(bloc),
            SizedBox(
              height: 30.0,
            ),
            _password(bloc),
            SizedBox(
              height: 30.0,
            ),
            _loginButton(bloc),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
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
