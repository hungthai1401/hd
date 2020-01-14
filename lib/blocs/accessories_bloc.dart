import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/services/accessory_service.dart';
import 'package:rxdart/rxdart.dart';

class AccessoriesBloc {
  final BehaviorSubject<AccessoryResponseModel> _subject =
      BehaviorSubject<AccessoryResponseModel>();

  fetchAccessories(SubCategoryModel subCategory) async {
    AccessoryResponseModel response =
        await AccessoryService.fetchAccessories(subCategory);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<AccessoryResponseModel> get subject => _subject;
}
