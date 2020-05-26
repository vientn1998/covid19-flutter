import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';

abstract class DeathState extends Equatable {
  const DeathState();
}

class InitialDeathState extends DeathState {
  @override
  List<Object> get props => [];
}

class Covid19DeathsLoading extends DeathState{
  @override
  List<Object> get props => [];
}

class Covid19LoadedDeaths extends DeathState {

  final List<DeathsObj> list;
  Covid19LoadedDeaths({@required this.list});

  @override
  List<Object> get props => [this.list];
}