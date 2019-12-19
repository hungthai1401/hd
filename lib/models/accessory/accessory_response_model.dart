import 'package:flutter/cupertino.dart';
import 'package:hd/models/accessory/accessory_model.dart';

class AccessoryResponseModel {
  final List<AccessoryModel> results;
  final String error;

  AccessoryResponseModel({@required this.results, @required this.error})
      : assert(results is List);

  AccessoryResponseModel.fromJson(List json)
      : results = json.map((item) => AccessoryModel.fromJson(item)).toList(),
        error = '';

  AccessoryResponseModel.withError(String error)
      : results = List(),
        error = error;
}
