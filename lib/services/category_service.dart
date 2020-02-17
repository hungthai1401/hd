import 'package:dio/dio.dart';
import 'package:hd/models/category/category_response_model.dart';
import 'package:hd/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static Future<CategoryResponseModel> fetchCategories() async {
    try {
      final String _endpoint = '${Constants.API_URL}/parent-category';
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

      Response response = await _dio.get(_endpoint);
      return CategoryResponseModel.fromJson(response.data, response.statusCode);
    } on DioError catch (error) {
      return CategoryResponseModel.withError(
          error.toString(), error.response?.statusCode);
    }
  }
}
