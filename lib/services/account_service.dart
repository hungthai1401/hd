import 'package:dio/dio.dart';
import 'package:hd/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static Future<bool> updateAccount(Map<String, dynamic> data) async {
    try {
      final String _endpoint = '${Constants.API_URL}/user';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      Dio _dio = Dio();

      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          options.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          };
          return options;
        },
      ));

      FormData formData = new FormData.fromMap(data);

      Response response = await _dio.post(_endpoint, data: formData);
      Map<String, dynamic> json = response.data;

      if (json['token'] != false) {
        await prefs.setString('token', json['token']);
      }

      Map<String, dynamic> user = json['user'];
      await prefs.setString('fullname', user['fullname']);
      await prefs.setString('address', user['address']);
      await prefs.setString('phone', user['phone']);
      return true;
    } catch (error) {
      return false;
    }
  }
}
