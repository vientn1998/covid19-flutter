import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/models/covid19/country.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  Covid19Dao covid19dao;

  List<CountryObj> listCountry = [];
  List<CountryObj> listCountryLocal = [];

  SearchBloc({@required this.covid19dao});

  @override
  SearchState get initialState => LoadingSearchLocal();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is LoadingSearch) {
      yield LoadingSearchLocal();
      yield* _mapDataLocalToState();
    } else if (event is AddSearch) {
      await covid19dao.insert(event.countryObj);
      yield AddSearchLocal();
    } else if (event is LoadingSearchFile) {
      yield LoadingFile();
      yield* _mapDataFileToState(event);
    } else if (event is FetchSearchFile) {
      yield* _mapDataSearchFileToState(event);
    }
  }

  Stream<SearchState> _mapDataSearchFileToState(FetchSearchFile event) async* {
    yield LoadingSearchLocal();
    final data = listCountry.where((element) => element.countryName.contains(event.keySearch)).toList();
    print('list data search ${data.length}');
    yield LoadedSearchFile(list: data);
  }

  Stream<SearchState> _mapDataFileToState(LoadingSearchFile event) async* {
    String data = await parseJson();
    final jsonResult = jsonDecode(data) as List;
    listCountry = jsonResult.map((item) => CountryObj.fromJson(item)).toList();
    print('count data country ${listCountry.length}');
    yield LoadedSearchFile(list: listCountry);
  }



  Future<String>_loadFromAsset() async {
    return await rootBundle.loadString("assets/data/data_search.json");
  }

  Future<String> parseJson() async {
    return await _loadFromAsset();
  }

  Stream<SearchState> _mapDataLocalToState() async* {
    listCountryLocal = await covid19dao.getAllSortedByName();
    yield LoadedSearchLocal(list: listCountryLocal);
  }
}
