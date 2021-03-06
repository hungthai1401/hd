import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/services/register_service.dart';
import 'package:rxdart/rxdart.dart';

import 'validator.dart';

class RegisterBloc with Validator {
  final BehaviorSubject<String> _userNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<bool> _succeed = BehaviorSubject<bool>();

  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get userName =>
      _userNameController.stream.transform(validateUserName);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => CombineLatestStream.combine2(
      userName, password, (userName, password) => true);
  Stream<bool> get succeed => _succeed.stream;

  register(BuildContext context) async {
    final _validUserName = _userNameController.value;
    final _validPassword = _passwordController.value;
    try {
      await RegisterService.register(_validUserName, _validPassword);
      _succeed.sink.add(true);
    } catch (e) {
      _succeed.sink.addError(FlutterI18n.translate(context, 'error'));
    }
  }

  void dispose() {
    _userNameController.close();
    _passwordController.close();
    _succeed.close();
  }
}
