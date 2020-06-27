import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/schedule_day_model.dart';
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
  final DateTime dateTimeCreated;
  CreateScheduleSuccess({@required this.dateTimeCreated});
  @override
  // TODO: implement props
  List<Object> get props => [this.dateTimeCreated];
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
  final bool isShowDialogCreate;
  final DateTime dateTime;
  FetchScheduleSuccess({@required this.list, this.isShowDialogCreate, this.dateTime});
  @override
  List<Object> get props => [this.list];
  @override
  String toString() {
    return 'FetchScheduleSuccess';
  }
}

class FetchAllScheduleByDoctorSuccess extends ScheduleState {
  final List<ScheduleDayModel> list;
  FetchAllScheduleByDoctorSuccess({@required this.list});
  @override
  List<Object> get props => [this.list];
}

class ErrorFetchAllSchedule extends ScheduleState {
  @override
  String toString() {
    return 'ErrorFetchSchedule';
  }
}