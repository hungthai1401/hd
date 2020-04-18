import 'package:flutter/material.dart';
import 'package:hd/blocs/auth_bloc.dart';
import 'package:hd/screens/auth/login_page.dart';
import 'package:hd/screens/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthBloc bloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    bloc.showRegisterButton();
    bloc.hasRegisterButton.listen((state) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (state) {
        await prefs.setBool('show-account', false);
        Navigator.of(context).pushReplacementNamed(HomePage.name);
      } else {
        checkToken();
      }
    });
  }

  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _token = prefs.getString('token');
    await Future.delayed(Duration(
      seconds: 3,
    ));
    _token != null
        ? Navigator.of(context).pushReplacementNamed(HomePage.name)
        : Navigator.of(context).pushReplacementNamed(LoginPage.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
