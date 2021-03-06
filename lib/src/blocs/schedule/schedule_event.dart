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

class GetScheduleLoadMore extends ScheduleEvent {
  bool isLoadMore = false;
  GetScheduleLoadMore({this.isLoadMore = false});
}



class GetScheduleByDay extends ScheduleEvent {
  final String idDoctor;
  final DateTime date;
  final bool isShow;
  GetScheduleByDay({@required this.idDoctor, this.date, this.isShow});
}

class GetScheduleDayByDoctor extends ScheduleEvent {
  final String idDoctor;
  final StatusSchedule statusSchedule;
  DateTime fromDate;
  GetScheduleDayByDoctor({@required this.idDoctor, this.fromDate, this.statusSchedule});
}

class GetScheduleLoadMoreByUesr extends ScheduleEvent {
  final String idUser;
  final StatusSchedule statusSchedule;
  DateTime fromDate, toDate;
  bool isLoadMore;
  GetScheduleLoadMoreByUesr({this.isLoadMore = false, @required this.idUser, this.fromDate, this.toDate, this.statusSchedule = StatusSchedule.New});
}

class GetScheduleByUesr extends ScheduleEvent {
  final String idUser;
  final StatusSchedule statusSchedule;
  DateTime fromDate, toDate;
  GetScheduleByUesr({@required this.idUser, this.fromDate, this.toDate, this.statusSchedule = StatusSchedule.New});
}

class GetScheduleByDoctor extends ScheduleEvent {
  final String idDoctor;
  final StatusSchedule statusSchedule;
  DateTime fromDate;
  GetScheduleByDoctor({@required this.idDoctor, this.fromDate, this.statusSchedule});
}

class GetScheduleAllByDoctor extends ScheduleEvent {
  final String idDoctor;
  GetScheduleAllByDoctor({@required this.idDoctor});
}


class UpdateSchedule extends ScheduleEvent {
  final String idSchedule;
  final StatusSchedule statusSchedule;
  UpdateSchedule({@required this.idSchedule, this.statusSchedule});
}

class GetScheduleLocalPushReminder extends ScheduleEvent {
  final String idUser;
  DateTime fromDate;
  final isDoctor;
  GetScheduleLocalPushReminder({@required this.idUser, @required this.fromDate, @required this.isDoctor});
}

class GetScheduleLocalPushNewByDoctor extends ScheduleEvent {
  final String idDoctor;
  DateTime fromDate;
  GetScheduleLocalPushNewByDoctor({@required this.idDoctor, @required this.fromDate});
}

class GetScheduleLocalPushNewEventSuccess extends ScheduleEvent {
  final ScheduleModel item;
  GetScheduleLocalPushNewEventSuccess({@required this.item});
}

class GetScheduleLocalPushNewEventSuccessTotal extends ScheduleEvent {
  final String idDoctor;
  DateTime fromDate;
  GetScheduleLocalPushNewEventSuccessTotal({@required this.idDoctor, this.fromDate});
}

class GetScheduleLocalPushChangeStatusOfUser extends ScheduleEvent {
  final String idUser;
  DateTime fromDate;
  GetScheduleLocalPushChangeStatusOfUser({@required this.idUser, @required this.fromDate});
}

class GetScheduleLocalPushChangeStatusOfUserEventSuccess extends ScheduleEvent {
  final ScheduleModel item;
  GetScheduleLocalPushChangeStatusOfUserEventSuccess({@required this.item});
}

class GetScheduleDetailsById extends ScheduleEvent {
  final String id, idDoctor;
  GetScheduleDetailsById({@required this.id, @required this.idDoctor});
}


