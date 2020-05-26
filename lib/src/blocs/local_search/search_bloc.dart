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
      print('list local: ${listCountryLocal.length}');
      if (listCountryLocal.length > 0) {
        print(listCountryLocal[0].countrySearch);
        print(event.countryObj.countrySearch);
        final country = listCountryLocal.where((element) => element.countrySearch == event.countryObj.countrySearch.toString()).toList();
        if (country.length == 0) {
          listCountryLocal.add(event.countryObj);
          await covid19dao.insert(event.countryObj);
          yield AddSearchLocal();
        }

      } else {
        listCountryLocal.add(event.countryObj);
        await covid19dao.insert(event.countryObj);
      }

    } else if (event is LoadingSearchFile) {
      yield LoadingFile();
      yield* _mapDataFileToState(event);
    } else if (event is FetchSearchFile) {
      yield* _mapDataSearchFileToState(event);
    } else if (event is DeleteSearch) {
      yield LoadingSearchLocal();
      await covid19dao.delete(event.countryObj);
      yield* _mapDataLocalToState();
    }
  }

  Stream<SearchState> _mapDataSearchFileToState(FetchSearchFile event) async* {
    yield LoadingSearchLocal();
    listCountryLocal.clear();
    listCountryLocal.addAll(await covid19dao.getAllSortedByName());
    final data = listCountry.where((element) => element.countryName.contains(event.keySearch)).toList();
    print('data searching ${data.length}');
    yield LoadedSearchFile(list: data);
  }

  Stream<SearchState> _mapDataFileToState(LoadingSearchFile event) async* {
    String data = await parseJson();
    final jsonResult = jsonDecode(data) as List;
    listCountry.clear();
    listCountry.addAll(jsonResult.map((item) => CountryObj.fromJson(item)).toList());
    print('All country ${listCountry.length}');
    yield LoadedSearchFile(list: listCountry);
  }

  Future<String>_loadFromAsset() async {
    return await rootBundle.loadString("assets/data/data_search.json");
  }

  Future<String> parseJson() async {
    return await _loadFromAsset();
  }

  Stream<SearchState> _mapDataLocalToState() async* {
    listCountryLocal.clear();
    listCountryLocal.addAll(await covid19dao.getAllSortedByName());
    yield LoadedSearchLocal(list: listCountryLocal);
  }
}
