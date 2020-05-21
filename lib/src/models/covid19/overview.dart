import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/Country.dart';

class ReportsObj extends Equatable {
  final List<TableObj> listData;

  ReportsObj({this.listData});

  factory ReportsObj.fromJson(Map<String, dynamic> parsedJson) {
    final json = parsedJson['table'] as List;
    final data = json.map((item) => TableObj.fromJson(item));
    return ReportsObj(
        listData: data
    );
  }

  @override
  List<Object> get props => [this.listData];
}

class TableObj extends Equatable {
  final List<OverviewObj> listOverview;

  TableObj({this.listOverview});

  factory TableObj.fromJson(dynamic parsedJson) {
    final data = parsedJson.map((item) => OverviewObj.fromJson(item));
    return TableObj(
        listOverview: data
    );
  }

  @override
  List<Object> get props => [this.listOverview];
}


class OverviewObj extends Equatable{
  String totalCases;
  String newCases;
  String totalDeaths;
  String newDeaths;
  String totalRecovered;
  String activeCases;
  String population;
  String country;
  String continent;
  String seriousCritical;

  OverviewObj({
    this.totalCases,
    this.newCases,
    this.totalDeaths,
    this.newDeaths,
    this.totalRecovered,
    this.activeCases,
    this.population,
    this.country,
    this.continent,
    this.seriousCritical,
  });

  factory OverviewObj.fromJson(Map<String, dynamic> parsedJson) {
    return OverviewObj(
      totalCases: parsedJson['TotalCases'],
      newCases: parsedJson['NewCases'],
      totalDeaths: parsedJson['TotalDeaths'],
      newDeaths: parsedJson['NewDeaths'],
      totalRecovered: parsedJson['TotalRecovered'],
      activeCases: parsedJson['ActiveCases'],
      population: parsedJson['Population'],
      country: parsedJson['Country'],
      continent: parsedJson['Continent'],
    );
  }

  @override
  List<Object> get props => [this.country, this.continent];


}
