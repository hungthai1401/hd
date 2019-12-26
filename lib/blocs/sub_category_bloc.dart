import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_response_model.dart';
import 'package:hd/services/sub_category_service.dart';
import 'package:rxdart/rxdart.dart';

class SubCategoryBloc {
  final BehaviorSubject<SubCategoryResponse> _subject =
      BehaviorSubject<SubCategoryResponse>();

  fetchSubCategories(CategoryModel category) async {
    SubCategoryResponse response =
        await SubCategoryService.fetchSubCategories(category);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SubCategoryResponse> get subject => _subject;
}
