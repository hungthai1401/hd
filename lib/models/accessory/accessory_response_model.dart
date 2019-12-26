import 'package:flutter/cupertino.dart';
import 'package:hd/models/accessory/accessory_model.dart';

class AccessoryResponseModel {
  final List<AccessoryModel> results;

  final String error;

  final int statusCode;

  AccessoryResponseModel(
      {@required this.results, @required this.error, @required this.statusCode})
      : assert(results is List);

  AccessoryResponseModel.fromJson(Map<String, dynamic> json, int statusCode)
      : results = (json['data'] as List)
            .map((item) => AccessoryModel.fromJson(item))
            .toList(),
        statusCode = statusCode,
        error = '';

  AccessoryResponseModel.withError(String error, int statusCode)
      : results = List(),
        statusCode = statusCode,
        error = error;
}
