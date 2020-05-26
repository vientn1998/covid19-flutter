import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CountryObj extends Equatable{
  int id;
  int updated;
  String country;
  String countryName;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;

  Map<String, dynamic> toMap() {
    return {
      'country' : this.country,
      'countryName' : this.countryName
    };
  }


  CountryObj({
    this.updated,
    this.country,
    this.cases,
    this.todayCases,
    this.todayDeaths,
    this.recovered,
    this.active,
    this.critical,
    this.countryName
  });

  factory CountryObj.fromJson(Map<String, dynamic> parsedJson) {
    return CountryObj(
      country: parsedJson['country'],
      countryName: parsedJson['countryName'],
    );
  }


  @override
  List<Object> get props => [
    this.updated,
    this.country
  ];

}

class CountryInfo extends Equatable{
  int iId;
  double lat;
  double long;
  String flag;

  CountryInfo({
    this.iId,
    this.lat,
    this.long,
    this.flag,
  });

  factory CountryInfo.fromJson(Map<String, dynamic> parsedJson) {
    return CountryInfo(
      iId: parsedJson['iId'],
      lat: parsedJson['lat'],
      long: parsedJson['long'],
      flag: parsedJson['flag'],
    );
  }

  @override
  List<Object> get props => [this.iId];
}