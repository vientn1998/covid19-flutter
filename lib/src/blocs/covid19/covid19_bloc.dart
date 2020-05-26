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

  Covid19Bloc({@required this.covid19repository}) : assert(covid19repository != null);

  @override
  Covid19State get initialState => InitialCovid19State();

  @override
  Stream<Covid19State> mapEventToState(
    Covid19Event event,
  ) async* {
    if (event is FetchDataOverview) {
      yield* _mapFetchDataOverviewToState(event);
    }
  }



  Stream<Covid19State> _mapFetchDataOverviewToState(FetchDataOverview event) async* {
    yield Covid19Loading();
    if (listData.isEmpty) {
      listData.addAll(await covid19repository.getDataOverview());
      if (event.countryName == null || event.countryName.isEmpty) {
        dataGlobal = listData[0];
        yield Covid19LoadedOverview(overviewObj: dataGlobal);
      } else {
        dataCountry = listData.firstWhere((element) => element.country == event.countryName);
        yield Covid19LoadedOverview(overviewObj: dataCountry);
      }
    } else {
      if (event.countryName == null || event.countryName.isEmpty) {
        dataGlobal = listData[0];
        yield Covid19LoadedOverview(overviewObj: dataGlobal);
      } else {
        try{
          dataCountry = listData.firstWhere((country) => country.country.toLowerCase().contains(event.countryName.toString().toLowerCase()));
          yield Covid19LoadedOverview(overviewObj: dataCountry);
        } on Exception catch (exception) {
          print(exception.toString());
          dataCountry = listData.firstWhere((element) => element.country == "Vietnam");
          yield Covid19LoadedOverview(overviewObj: dataCountry);
        }
      }
    }
  }
}
