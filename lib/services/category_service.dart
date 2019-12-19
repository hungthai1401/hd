import 'package:dio/dio.dart';
import 'package:hd/models/category/category_response_model.dart';

class CategoryService {
  static const String _endpoint =
      'http://www.mocky.io/v2/5dfa498b360000e999bd6bf0';

  static Future<CategoryResponseModel> fetchCategories() async {
    try {
      Response response = await Dio().get(_endpoint);
      return CategoryResponseModel.fromJson(response.data);
    } catch (error) {
      return CategoryResponseModel.withError(error);
    }
  }
}
