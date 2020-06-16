
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class KeyValueObj extends Equatable{
  int id;
  String key;
  String value;

  KeyValueObj({this.key, this.value});

  KeyValueObj copyWith({String key, String value}) {
    return KeyValueObj(key: key, value: value);
  }

  static KeyValueObj fromJson(Map<String, Object> json) {
    return KeyValueObj(
      key: json['key'] as String,
      value: json['value'] as String,
    );
  }

  static KeyValueObj fromDocument(DocumentSnapshot documentSnapshot) {
    return KeyValueObj(
      key: documentSnapshot.data['key'],
      value: documentSnapshot.data['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  @override
  String toString() {
    return '$key: $value';
  }

  @override
  List<Object> get props => [key, value];
}