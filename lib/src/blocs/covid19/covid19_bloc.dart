import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/repositories/covid19/covid_repository.dart';
import './bloc.dart';

class Covid19Bloc extends Bloc<Covid19Event, Covid19State> {
  var dataGlobal = OverviewObj();
  var dataCountry = OverviewObj();
  List<OverviewObj> listData = [];
  final Covid19Repository covid19repository;

  Covid19Bloc({@required this.covid19repository})
      : assert(covid19repository != null);

  @override
  Covid19State get initialState => InitialCovid19State();

  @override
  Stream<Covid19State> mapEventToState(
    Covid19Event event,
  ) async* {
    if (event is FetchDataOverview) {
      yield* _mapFetchDataOverviewToState(event);
    } else if (event is FetchAllCountryNewCase) {
      yield* _mapFetchNewCaseToState(event);
    }
  }

  Stream<Covid19State> _mapFetchNewCaseToState(
      FetchAllCountryNewCase event) async* {
    yield Covid19LoadingNewCase();
    try {
      if (event.isNewCase != null && event.isNewCase) {
        final list = listData
            .where((data) => ((data.newCases.trim().isNotEmpty &&
                !data.country.trim().contains("World"))))
            .toList();
        final data = list
            .where((element) => element.country.contains(event.keySearch))
            .toList();
        data.sort((a, b) => b.newCase.compareTo(a.newCase));
        yield Covid19LoadedNewCase(list: data);
      } else {
        final list = listData
            .where((data) => ((data.newDeaths.trim().isNotEmpty &&
            !data.country.trim().contains("World"))))
            .toList();
        final data = list
            .where((element) => element.country.contains(event.keySearch))
            .toList();
        data.sort((a, b) => b.newDeath.compareTo(a.newDeath));
        yield Covid19LoadedNewCase(list: data);
      }
    } on Exception catch (exception) {
      print(exception.toString());
      yield Covid19LoadedNewCase(list: []);
    }
  }

  Stream<Covid19State> _mapFetchDataOverviewToState(
      FetchDataOverview event) async* {
    yield Covid19Loading();
    if (listData.isEmpty) {
      listData.addAll(await covid19repository.getDataOverview());
      if (event.countryName == null || event.countryName.isEmpty) {
        dataGlobal = listData[0];
        yield Covid19LoadedOverview(overviewObj: dataGlobal);
      } else {
        dataCountry = listData
            .firstWhere((element) => element.country == event.countryName);
        yield Covid19LoadedOverview(overviewObj: dataCountry);
      }
    } else {
      if (event.countryName == null || event.countryName.isEmpty) {
        dataGlobal = listData[0];
        yield Covid19LoadedOverview(overviewObj: dataGlobal);
      } else {
        try {
          dataCountry = listData.firstWhere((country) => country.country
              .toLowerCase()
              .contains(event.countryName.toString().toLowerCase()));
          yield Covid19LoadedOverview(overviewObj: dataCountry);
        } on Exception catch (exception) {
          print(exception.toString());
          dataCountry =
              listData.firstWhere((element) => element.country == "Vietnam");
          yield Covid19LoadedOverview(overviewObj: dataCountry);
        }
      }
    }
  }
}
