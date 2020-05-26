import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CountryObj extends Equatable{
  int id;
  String country;
  String countryName;
  String countrySearch;
  String code;

  Map<String, dynamic> toMap() {
    return {
      'country' : this.country,
      'countrySearch' : this.countrySearch,
      'code' : this.code,
      'countryName' : this.countryName
    };
  }


  CountryObj({
    this.country,
    this.countrySearch,
    this.code,
    this.countryName
  });

  factory CountryObj.fromJson(Map<String, dynamic> parsedJson) {
    return CountryObj(
      country: parsedJson['country'],
      countrySearch: parsedJson['countrySearch'],
      code: parsedJson['code'],
      countryName: parsedJson['countryName'],
    );
  }


  @override
  List<Object> get props => [
    this.countryName,
    this.countrySearch,
    this.code,
    this.country
  ];

}