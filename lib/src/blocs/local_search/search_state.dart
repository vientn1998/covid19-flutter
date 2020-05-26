import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/country.dart';

abstract class SearchState extends Equatable {

  const SearchState();
  @override
  List<Object> get props => [];

}
class LoadingSearchLocal extends SearchState{}

class LoadedSearchLocal extends SearchState{
  List<CountryObj> list = [];
  LoadedSearchLocal({@required this.list});
}

class AddSearchLocal extends SearchState{}

class LoadingFile extends SearchState{}

class LoadedSearchFile extends SearchState{
  List<CountryObj> list = [];
  LoadedSearchFile({@required this.list});
}