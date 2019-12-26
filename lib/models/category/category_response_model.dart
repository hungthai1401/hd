import 'package:flutter/cupertino.dart';
import 'package:hd/models/category/category_model.dart';

class CategoryResponseModel {
  final List<CategoryModel> results;

  final String error;

  final int statusCode;

  CategoryResponseModel(
      {@required this.results, @required this.error, @required this.statusCode})
      : assert(results is List);

  CategoryResponseModel.fromJson(Map<String, dynamic> json, int statusCode)
      : results = (json['data'] as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList(),
        statusCode = statusCode,
        error = '';

  CategoryResponseModel.withError(String error, int statusCode)
      : results = List(),
        statusCode = statusCode,
        error = error;
}
