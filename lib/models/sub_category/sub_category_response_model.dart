import 'package:flutter/cupertino.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';

class SubCategoryResponse {
  final List<SubCategoryModel> results;

  final String error;

  final int statusCode;

  SubCategoryResponse(
      {@required this.results, @required this.error, @required this.statusCode})
      : assert(results is List);

  SubCategoryResponse.fromJson(Map<String, dynamic> json, int statusCode)
      : results = (json['data'] as List)
            .map((item) => SubCategoryModel.fromJson(item))
            .toList(),
        statusCode = statusCode,
        error = '';

  SubCategoryResponse.withError(String error, int statusCode)
      : results = List(),
        statusCode = statusCode,
        error = error;
}
