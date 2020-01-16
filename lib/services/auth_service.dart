import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hd/models/user/user_response_model.dart';

class AuthService {
  static Future<UserResponseModel> attempt(
      String userName, String password) async {
    final String _endpoint = '${FlutterConfig.get('API_URL')}/auth/login';
    FormData formData = new FormData.fromMap({
      'username': userName,
      'password': password,
    });

    Response response = await Dio().post(_endpoint, data: formData);
    return UserResponseModel.fromJson(response.data);
  }
}
