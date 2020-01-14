import 'package:hd/models/category/category_response_model.dart';
import 'package:hd/services/category_service.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final BehaviorSubject<CategoryResponseModel> _subject =
      BehaviorSubject<CategoryResponseModel>();

  fetchCategories() async {
    CategoryResponseModel response = await CategoryService.fetchCategories();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CategoryResponseModel> get subject => _subject;
}
