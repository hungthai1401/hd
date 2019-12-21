import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory_image/accessory_image_response_model.dart';
import 'package:hd/services/accessory_image_service.dart';
import 'package:rxdart/rxdart.dart';

class AccessoryBloc {
  BehaviorSubject<AccessoryImageResponse> _subject =
      BehaviorSubject<AccessoryImageResponse>();

  void findAccessoryImage(AccessoryModel accessory) async {
    AccessoryImageResponse response =
        await AccessoryImageService.findAccessoryImage(accessory);
    _subject.sink.add(response);
  }

  void dispose() {
    _subject.close();
  }

  BehaviorSubject<AccessoryImageResponse> get subject => _subject;
}
