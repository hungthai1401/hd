import 'package:dio/dio.dart';
import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/category/category_model.dart';

class AccessoryService {
  static Future<AccessoryResponseModel> fetchAccessories(
      CategoryModel category) async {
    final String _endpoint = 'http://www.mocky.io/v2/5dfa498b360000e999bd6bf0';
    try {
      Response response = await Dio().get(_endpoint);
      return AccessoryResponseModel.fromJson(response.data);
    } catch (error) {
      return AccessoryResponseModel.withError(error);
    }
  }
}
