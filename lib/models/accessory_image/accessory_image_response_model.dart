import 'package:hd/models/accessory_image/accessory_image_model.dart';

class AccessoryImageResponse {
  final AccessoryImageModel result;
  final String error;

  AccessoryImageResponse({this.result, this.error})
      : assert(result is AccessoryImageModel);

  AccessoryImageResponse.fromJson(List json)
      : result = AccessoryImageModel.fromJson(json[0]),
        error = '';

  AccessoryImageResponse.withError(String error)
      : result = null,
        error = error;
}
