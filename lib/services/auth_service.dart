import 'package:dio/dio.dart';
import 'package:hd/models/user/user_response_model.dart';
import 'package:hd/utilities/constants.dart';

class AuthService {
  static Future<bool> showRegisterButton() async {
    final String _endpoint = '${Constants.API_URL}/show-button';
    Response response = await Dio().get(_endpoint);
    Map<String, dynamic> data = response.data;
    return data['flag'] ?? false;
  }

  static Future<UserResponseModel> attempt(
      String userName, String password) async {
    final String _endpoint = '${Constants.API_URL}/auth/login';
    FormData formData = new FormData.fromMap({
      'username': userName,
      'password': password,
    });

    Response response = await Dio().post(_endpoint, data: formData);
    return UserResponseModel.fromJson(response.data);
  }
}
