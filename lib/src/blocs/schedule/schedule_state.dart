import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
  @override
  List<Object> get props => [];
}

class InitialScheduleState extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleLoading extends ScheduleState {

}

class ScheduleError extends ScheduleState {

}

class CreateScheduleSuccess extends ScheduleState {

}

class LoadingFetchSchedule extends ScheduleState {
  @override
  String toString() {
    return 'LoadingFetchSchedule';
  }
}

class ErrorFetchSchedule extends ScheduleState {
  @override
  String toString() {
    return 'ErrorFetchSchedule';
  }
}

class FetchScheduleSuccess extends ScheduleState {
  final List<ScheduleModel> list;
  FetchScheduleSuccess({@required this.list});
  @override
  List<Object> get props => [this.list];
  @override
  String toString() {
    return 'FetchScheduleSuccess';
  }
}