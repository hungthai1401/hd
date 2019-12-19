import 'package:hd/models/category/category_model.dart';

class CategoryResponseModel {
  final List<CategoryModel> results;

  final String error;

  CategoryResponseModel({this.results, this.error}) : assert(results is List);

  CategoryResponseModel.fromJson(List json)
      : results = json.map((item) => CategoryModel.fromJson(item)).toList(),
        error = '';

  CategoryResponseModel.withError(String error)
      : results = List(),
        error = error;
}
