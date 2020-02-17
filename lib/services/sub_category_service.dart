import 'package:dio/dio.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_response_model.dart';
import 'package:hd/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryService {
  static Future<SubCategoryResponse> fetchSubCategories(
      CategoryModel category) async {
    try {
      final String _endpoint =
          '${Constants.API_URL}/category/${category.id}';
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
      return SubCategoryResponse.fromJson(response.data, response.statusCode);
    } on DioError catch (error) {
      return SubCategoryResponse.withError(
          error.toString(), error.response?.statusCode);
    }
  }
}
