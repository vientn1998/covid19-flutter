import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
  @override
  List<Object> get props => [];
}

class CreateSchedule extends ScheduleEvent {
  final ScheduleModel scheduleModel;
  CreateSchedule({@required this.scheduleModel});
}
