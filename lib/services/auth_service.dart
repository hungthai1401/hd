import 'package:dio/dio.dart';
import 'package:hd/models/user/user_response_model.dart';

class AuthService {
  static const String _endpoint = 'http://171.244.49.71:7009/api/auth/login';

  static Future<UserResponseModel> attempt(
      String userName, String password) async {
    Response response = await Dio().post(_endpoint, data: {
      'username': userName,
      'password': password,
    });
    return UserResponseModel.fromJson(response.data);
  }
}
