import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static const _endpoint = 'http://171.244.49.71:7009/api/user';

  static Future<bool> updateAccount(Map<String, dynamic> data) async {
    try {
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
      print(error.toString());
      return false;
    }
  }
}
