import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
  @override
  List<Object> get props => [];
}

class InitSchedule extends ScheduleEvent {
}

class CreateSchedule extends ScheduleEvent {
  final ScheduleModel scheduleModel;
  final DateTime dateTimeCreate;
  CreateSchedule({@required this.scheduleModel, this.dateTimeCreate});
}

class GetScheduleByDay extends ScheduleEvent {
  final String idDoctor;
  final DateTime date;
  final bool isShow;
  GetScheduleByDay({@required this.idDoctor, this.date, this.isShow});
}

class GetScheduleByDoctor extends ScheduleEvent {
  final String idDoctor;
  DateTime fromDate;
  GetScheduleByDoctor({@required this.idDoctor, this.fromDate});
}