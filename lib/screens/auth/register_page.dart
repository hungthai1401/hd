import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hd/blocs/register_bloc.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RegisterPage extends StatefulWidget {
  static const String name = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bloc = RegisterBloc();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    bloc.succeed.listen((state) {
      if (state) {
        Navigator.of(context).pushReplacementNamed(LoginPage.name);
      }
    });
  }

  Widget _userName(RegisterBloc bloc) => StreamBuilder<String>(
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

  Widget _password(RegisterBloc bloc) => StreamBuilder<String>(
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

  Widget _registerButton(RegisterBloc bloc) => StreamBuilder<bool>(
        stream: bloc.submitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return RaisedButton(
            onPressed: () => snapshot.hasData ? bloc.register(context) : null,
            color: Colors.redAccent,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                FlutterI18n.translate(context, 'btn.register').toUpperCase(),
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

  Widget _alert(RegisterBloc bloc) => StreamBuilder<bool>(
        stream: bloc.succeed,
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
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'title.register'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                child: Image.asset('assets/icon/icon.png'),
                width: 150,
                height: 150,
              ),
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
              _registerButton(bloc),
            ],
          ),
        ),
      ),
    );
  }
}
