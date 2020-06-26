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
  CreateSchedule({@required this.scheduleModel});
}

class GetScheduleByDay extends ScheduleEvent {
  final String idDoctor;
  final int date;
  GetScheduleByDay({@required this.idDoctor, this.date});
}
