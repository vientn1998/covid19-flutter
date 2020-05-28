import 'package:equatable/equatable.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

abstract class Covid19Event extends Equatable {
  const Covid19Event();
}

class FetchDataOverview extends Covid19Event {
  String countryName = "";
  bool isLoadData = true;
  FetchDataOverview({this.countryName, this.isLoadData});
  @override
  List<Object> get props => [this.countryName];
}

class FetchDataByCountryName extends Covid19Event {
  final String city;

  FetchDataByCountryName({@required this.city}): assert(city != null);

  @override
  List<Object> get props => [city];

}

class FetchAllCountry extends Covid19Event {
  @override
  List<Object> get props => [];
}

class FetchAllCountryNewCase extends Covid19Event {

  FetchAllCountryNewCase();

  @override
  List<Object> get props => [];
}




