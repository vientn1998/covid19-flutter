import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/country.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class LoadingSearch extends SearchEvent{}

class LoadedSearch extends SearchEvent{

  String keySearch;
  LoadedSearch({@required this.keySearch});

  @override
  List<Object> get props => [this.keySearch];
}

class AddSearch extends SearchEvent{

  CountryObj countryObj;
  AddSearch({@required this.countryObj});

  @override
  List<Object> get props => [this.countryObj];
}

class DeleteSearch extends SearchEvent {
  CountryObj countryObj;
  DeleteSearch({@required this.countryObj});

  @override
  List<Object> get props => [this.countryObj];
}

class LoadingSearchFile extends SearchEvent{
  BuildContext context;

  LoadingSearchFile({@required this.context});
}

class FetchSearchFile extends SearchEvent{

  String keySearch;
  FetchSearchFile({@required this.keySearch});

  @override
  List<Object> get props => [this.keySearch];
}
