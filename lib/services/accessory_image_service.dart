import 'package:dio/dio.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory_image/accessory_image_response_model.dart';

class AccessoryImageService {
  static Future<AccessoryImageResponse> findAccessoryImage(
      AccessoryModel accessory) async {
    final String _endpoint = 'http://www.mocky.io/v2/5dfe340e3100000a1fc96ef4';
    try {
      Response response = await Dio().get(_endpoint);
      return AccessoryImageResponse.fromJson(response.data);
    } catch (error) {
      return AccessoryImageResponse.withError(error);
    }
  }
}
