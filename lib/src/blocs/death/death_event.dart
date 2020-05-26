import 'package:equatable/equatable.dart';

abstract class DeathEvent extends Equatable {
  const DeathEvent();
}

class FetchAllDeaths extends DeathEvent {
  FetchAllDeaths();
  @override
  List<Object> get props => [];
}