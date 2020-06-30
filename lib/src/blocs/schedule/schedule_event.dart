import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/utils/define.dart';

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
  final StatusSchedule statusSchedule;
  DateTime fromDate;
  GetScheduleByDoctor({@required this.idDoctor, this.fromDate, this.statusSchedule});
}

class GetScheduleByUesr extends ScheduleEvent {
  final String idUser;
  final StatusSchedule statusSchedule;
  DateTime fromDate;
  GetScheduleByUesr({@required this.idUser, this.fromDate, this.statusSchedule = StatusSchedule.New});
}