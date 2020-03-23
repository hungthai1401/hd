import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/models/user/user_model.dart';
import 'package:hd/models/user/user_response_model.dart';
import 'package:hd/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'validator.dart';

class AuthBloc with Validator {
  final BehaviorSubject<String> _userNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<bool> _authenticate = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _showRegisterButton = BehaviorSubject<bool>();

  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get userName =>
      _userNameController.stream.transform(validateUserName);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => CombineLatestStream.combine2(
      userName, password, (userName, password) => true);
  Stream<bool> get authenticate => _authenticate.stream;
  Stream<bool> get hasRegisterButton => _showRegisterButton.stream;

  showRegisterButton() async {
    try {
      bool response = await AuthService.showRegisterButton();
      _showRegisterButton.sink.add(response);
    } catch (e) {
      _showRegisterButton.sink.add(false);
    }
  }

  attempt(BuildContext context) async {
    final _validUserName = _userNameController.value;
    final _validPassword = _passwordController.value;
    try {
      UserResponseModel response =
          await AuthService.attempt(_validUserName, _validPassword);
      UserModel user = response.result;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setInt('id', user.id);
      await prefs.setString('username', user.userName);
      await prefs.setString('fullname', user.fullName);
      await prefs.setString('address', user.address);
      await prefs.setString('phone', user.phone);
      await prefs.setBool('show-account', true);
      _authenticate.sink.add(true);
    } catch (e) {
      _authenticate.sink.addError(FlutterI18n.translate(context, 'error'));
    }
  }

  void dispose() {
    _userNameController.close();
    _passwordController.close();
    _authenticate.close();
    _showRegisterButton.close();
  }
}
