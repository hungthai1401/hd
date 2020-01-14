import 'package:flutter/cupertino.dart';
import 'package:hd/models/user/user_model.dart';

class UserResponseModel {
  final UserModel result;
  final String error;

  UserResponseModel({@required this.result, @required this.error});

  UserResponseModel.fromJson(Map<String, dynamic> json)
      : result = UserModel.fromJson(json['user'], json['token']),
        error = '';

  UserResponseModel.withError(String error)
      : result = null,
        error = error;
}
