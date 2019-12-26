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

      Response response = await _dio.put(_endpoint, data: data);
      Map<String, dynamic> json = response.data;
      await prefs.setString('token', json['data']);
      await prefs.setString('fullname', json['fullname']);
      await prefs.setString('address', json['address']);
      await prefs.setString('phone', json['phone']);
      return true;
    } on DioError catch (error) {
      print(error.toString());
      return false;
    }
  }
}
