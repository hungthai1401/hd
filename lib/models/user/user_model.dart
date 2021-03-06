import 'package:flutter/cupertino.dart';

class UserModel {
  final int id;
  final String userName;
  final String fullName;
  final String address;
  final String phone;
  final String token;

  UserModel(
      {@required this.id,
      @required this.userName,
      @required this.fullName,
      @required this.address,
      @required this.phone,
      @required this.token})
      : assert(id != null),
        assert(userName != null),
        assert(fullName != null),
        assert(address != null),
        assert(phone != null),
        assert(token != null);

  UserModel.fromJson(Map<String, dynamic> json, String token)
      : id = json['id'],
        userName = json['username'],
        fullName = json['fullname'],
        address = json['address'],
        phone = json['phone'],
        token = token;
}
