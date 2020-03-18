import 'package:dio/dio.dart';
import 'package:hd/models/account/account_response_model.dart';
import 'package:hd/utilities/constants.dart';

class RegisterService {
  static Future<AccountResponseModel> register(
      String userName, String password) async {
    final String _endpoint = '${Constants.API_URL}/user/create';
    FormData formData = new FormData.fromMap({
      'username': userName,
      'password': password,
    });

    await Dio().post(_endpoint, data: formData);
    return AccountResponseModel(result: true);
  }
}
