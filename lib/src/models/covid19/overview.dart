import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/Country.dart';

class ReportsObj extends Equatable {
  final List<List<OverviewObj>> listData;

  ReportsObj({this.listData});

  factory ReportsObj.fromJson(Map<String, dynamic> parsedJson) {
    final data = List<OverviewObj>();
    final dataParent = List<List<OverviewObj>>();
    final json = parsedJson['table'] as List;
    json.forEach((element) {
      print('-----');
      final list = element as List;
      list.forEach((child) {
        data.add(OverviewObj.fromJson(child));
      });
      dataParent.add(data);
    });
    return ReportsObj(
        listData: dataParent
    );
  }

  @override
  List<Object> get props => [this.listData];
}

class TableObj extends Equatable {
  final List<OverviewObj> listOverview;

  TableObj({this.listOverview});

  factory TableObj.fromJson(Map<String, dynamic> parsedJson) {
    final data = parsedJson.values.map((item) => OverviewObj.fromJson(item)).toList();
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
