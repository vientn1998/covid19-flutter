import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/repositories/covid19/covid_repository.dart';
import './bloc.dart';

class DeathBloc extends Bloc<DeathEvent, DeathState> {

  List<DeathsObj> listDataDeaths = [];
  final Covid19Repository covid19repository;

  DeathBloc({@required this.covid19repository}) : assert(covid19repository != null);

  @override
  DeathState get initialState => InitialDeathState();

  @override
  Stream<DeathState> mapEventToState(
    DeathEvent event,
  ) async* {
    if (event is FetchAllDeaths) {
      yield* _mapFetchDataDeathToState();
    }
  }

  Stream<DeathState> _mapFetchDataDeathToState() async* {
    yield Covid19DeathsLoading();
    if (listDataDeaths.length == 0) {
      final list = await covid19repository.getTotalDeaths();
      listDataDeaths.addAll(list);
      yield Covid19LoadedDeaths(list: listDataDeaths);
    } else {
      yield Covid19LoadedDeaths(list: listDataDeaths);
    }
  }
}
