import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessoryService {
  static Future<AccessoryResponseModel> fetchAccessories(
      SubCategoryModel subCategory, String keyword) async {
    try {
      final String _endpoint =
          '${FlutterConfig.get('API_URL')}/accessory/${subCategory.id}';

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

      Response response = await _dio.get(_endpoint, queryParameters: { 'keyword': keyword, });
      return AccessoryResponseModel.fromJson(
          response.data, response.statusCode);
    } on DioError catch (error) {
      return AccessoryResponseModel.withError(
          error.toString(), error.response?.statusCode);
    }
  }
}
