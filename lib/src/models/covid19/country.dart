import 'package:equatable/equatable.dart';

class CountryObj extends Equatable{
  int updated;
  String country;
  CountryInfo countryInfo;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;

  CountryObj({
    this.updated,
    this.country,
    this.countryInfo,
    this.cases,
    this.todayCases,
    this.todayDeaths,
    this.recovered,
    this.active,
    this.critical,
  });

  factory CountryObj.fromJson(Map<String, dynamic> parsedJson) {
    return CountryObj(
      updated: parsedJson['updated'],
      country: parsedJson['country'],
      cases: parsedJson['cases'],
      todayCases: parsedJson['todayCases'],
      todayDeaths: parsedJson['todayDeaths'],
      recovered: parsedJson['recovered'],
      active: parsedJson['active'],
      critical: parsedJson['critical'],
      countryInfo: CountryInfo.fromJson(parsedJson['countryInfo']),
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