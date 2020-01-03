import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/components/app_drawer.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/screens/home/home_page.dart';
import 'package:hd/services/account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  static const String name = '/profile';

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  bool _isFailed;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this._isFailed = false;
  }

  Future _updateAccount() async {
    Map<String, dynamic> data = Map();
    data['fullname'] = _fullNameController.text;
    data['phone'] = _phoneController.text;
    data['address'] = _addressController.text;

    if (_passwordController.text.length > 0) {
      data['password'] = _passwordController.text;
    }


    bool result = await AccountService.updateAccount(data);
    setState(() {
      this._isFailed = !result;
    });

    if (result) {
      Navigator.of(context).pushReplacementNamed(HomePage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _alert = Visibility(
      visible: _isFailed,
      child: Text(
        FlutterI18n.translate(context, 'error'),
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    Widget _userName(SharedPreferences _prefs) => TextFormField(
          autofocus: false,
          readOnly: true,
          decoration: InputDecoration(
            hintText: FlutterI18n.translate(context, 'username').toUpperCase(),
          ),
          initialValue: _prefs.getString('username'),
        );

    Widget _password(SharedPreferences _prefs) => TextFormField(
          controller: _passwordController,
          autofocus: false,
          obscureText: true,
          decoration: InputDecoration(
            hintText: FlutterI18n.translate(context, 'password').toUpperCase(),
          ),
        );

    Widget _fullName(SharedPreferences _prefs) {
      _fullNameController.text = _prefs.getString('fullname');
      return TextFormField(
        controller: _fullNameController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: FlutterI18n.translate(context, 'fullname').toUpperCase(),
        ),
      );
    }

    ;

    Widget _phone(SharedPreferences _prefs) {
      _phoneController.text = _prefs.getString('phone');
      return TextFormField(
        controller: _phoneController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: FlutterI18n.translate(context, 'phone').toUpperCase(),
        ),
      );
    }

    Widget _address(SharedPreferences _prefs) {
      _addressController.text = _prefs.getString('address');
      return TextFormField(
        controller: _addressController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: FlutterI18n.translate(context, 'address').toUpperCase(),
        ),
      );
    }

    final _saveButton = RaisedButton(
      onPressed: () => _updateAccount(),
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          FlutterI18n.translate(context, 'btn.update').toUpperCase(),
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
        title: Text(
          FlutterI18n.translate(context, 'title.account'),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getSharedPreferences(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              SharedPreferences prefs = snapshot.data;
              return Container(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _alert,
                    SizedBox(
                      height: 30.0,
                    ),
                    _userName(prefs),
                    SizedBox(
                      height: 30.0,
                    ),
                    _password(prefs),
                    SizedBox(
                      height: 30.0,
                    ),
                    _fullName(prefs),
                    SizedBox(
                      height: 30.0,
                    ),
                    _phone(prefs),
                    SizedBox(
                      height: 30.0,
                    ),
                    _address(prefs),
                    SizedBox(
                      height: 30.0,
                    ),
                    _saveButton,
                  ],
                ),
              );
            }

            return Skeleton();
          },
        ),
      ),
    );
  }
}
