import 'package:template_flutter/src/models/key_value_model.dart';

class MajorObj {

  int id;
  final List<KeyValueObj> list;

  MajorObj({this.list});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'list': list?.map((item) => item.toJson())?.toList(growable: false)
  };
}