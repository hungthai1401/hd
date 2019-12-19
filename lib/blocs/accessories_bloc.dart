import 'package:hd/models/accessory/accessory_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/services/accessory_service.dart';
import 'package:rxdart/rxdart.dart';

class AccessoriesBloc {
  final BehaviorSubject<AccessoryResponseModel> _subject =
      BehaviorSubject<AccessoryResponseModel>();

  fetchAccessories(CategoryModel category) async {
    AccessoryResponseModel response =
        await AccessoryService.fetchAccessories(category);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<AccessoryResponseModel> get subject => _subject;
}
