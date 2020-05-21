import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/repositories/covid19/covid_repository.dart';
import './bloc.dart';

class Covid19Bloc extends Bloc<Covid19Event, Covid19State> {

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
    final overviewObj = await covid19repository.getDataOverview(countryName: event.countryName);
    yield Covid19LoadedOverview(overviewObj: overviewObj);
  }

}
