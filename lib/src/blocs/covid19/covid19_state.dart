import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/country.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';

abstract class Covid19State extends Equatable {
  const Covid19State();
  @override
  List<Object> get props => [];
}

class InitialCovid19State extends Covid19State {
  @override
  List<Object> get props => [];
}

class Covid19Loading extends Covid19State {}

class Covid19Empty extends Covid19State {}

class Covid19Error extends Covid19State {}

class Covid19LoadedOverview extends Covid19State {

  final OverviewObj overviewObj;
  Covid19LoadedOverview({@required this.overviewObj}) : assert(overviewObj != null);

  @override
  List<Object> get props => [this.overviewObj];
}

class Covid19LoadedAllCountry extends Covid19State {

  final List<CountryObj> countries;

  Covid19LoadedAllCountry({@required this.countries}) : assert(countries != null);

  @override
  List<Object> get props => [this.countries];
}

class Covid19LoadedDataByCountryName extends Covid19State {

  final OverviewObj overviewObj;

  Covid19LoadedDataByCountryName({@required this.overviewObj}) : assert(overviewObj != null);

  @override
  List<Object> get props => [this.overviewObj];
}