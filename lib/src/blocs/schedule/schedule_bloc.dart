import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/repositories/schedule_repository.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  final ScheduleRepository scheduleRepository;
  int numberExamination = 0;
  ScheduleBloc(this.scheduleRepository);

  @override
  ScheduleState get initialState => InitialScheduleState();

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is CreateSchedule) {
      yield* _mapCreateToState(event);
    } else if (event is GetScheduleByDay) {
      yield* _mapFetchDataByDayToState(event);
    } else if (event is GetScheduleDayByDoctor) {
      yield* _mapFetchDataDayByDoctorToState(event);
    } else if (event is GetScheduleByUesr) {
      yield* _mapFetchScheduleByUserToState(event);
    } else if (event is GetScheduleByDoctor) {
      yield* _mapFetchScheduleByDoctorToState(event);
    } else if (event is UpdateSchedule) {
      yield* _mapUpdateScheduleToState(event);
    } else if (event is GetScheduleAllByDoctor) {
      yield* _mapFetchScheduleAllByDoctorToState(event);
    } else if (event is GetScheduleLocalPushReminder) {
      yield* _mapFetchScheduleLocalPushReminderToState(event);
    } else if (event is GetScheduleLocalPushNewByDoctor) {
      yield* _mapFetchScheduleLocalPushNewByDoctorToState(event);
    } else if (event is GetScheduleLocalPushNewEventSuccess) {
      yield* _mapFetchScheduleLocalPushNewSuccessToState(event);
    } else if (event is GetScheduleLocalPushNewEventSuccessTotal) {
      yield* _mapFetchScheduleLocalPushNewTotalSuccessToState(event);
    } else if (event is GetScheduleLocalPushChangeStatusOfUser) {
      yield* _mapFetchScheduleLocalPushChangeStatusOfUserToState(event);
    } else if (event is GetScheduleLocalPushChangeStatusOfUserEventSuccess) {
      yield* _mapFetchScheduleLocalPushChangeStatusOfUserSuccessToState(event);
    } else {
      yield InitialScheduleState();
    }
  }

  Stream<ScheduleState> _mapCreateToState(CreateSchedule event) async* {
    yield ScheduleLoading();
    final isSuccess = await scheduleRepository.createSchedule(event.scheduleModel);
    if (isSuccess != null && isSuccess == true) {
      numberExamination += 1;
      yield CreateScheduleSuccess(dateTimeCreated: event.dateTimeCreate);
    } else {
      yield ScheduleError();
    }
  }

  Stream<ScheduleState> _mapFetchDataByDayToState(GetScheduleByDay event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository.getScheduleByDoctorAndDay(event.idDoctor, event.date.millisecondsSinceEpoch);
      if (data != null) {
        yield FetchScheduleSuccess(list: data, isShowDialogCreate: event.isShow, dateTime: event.date);
        print('_mapFetchDataByDayToState : ${data.length}');
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchDataByDayToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchDataByDayToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchDataDayByDoctorToState(GetScheduleDayByDoctor event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository.getScheduleDayByDoctor(event.idDoctor);
      if (data != null) {
        yield FetchAllScheduleDayByDoctorSuccess(list: data);
        print('_mapFetchDataByDoctorToState : ${data.length}');
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchDataByDoctorToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchDataByDoctorToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleByDoctorToState(GetScheduleByDoctor event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository
          .getScheduleByDoctor(event.idDoctor, day: event.fromDate == null ? 0 : event.fromDate.millisecondsSinceEpoch, status: event.statusSchedule);
      if (data != null) {
        yield FetchAllScheduleByDoctorSuccess(list: data);
        print('_mapFetchDataByDoctorToState : ${data.length}');
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchDataByDoctorToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchDataByDoctorToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleAllByDoctorToState(GetScheduleAllByDoctor event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository
          .getScheduleAllByDoctor(event.idDoctor);
      if (data != null) {
        yield FetchAllTotalScheduleByDoctorSuccess(list: data);
        print('_mapFetchScheduleAllByDoctorToState : ${data.length}');
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchScheduleAllByDoctorToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleAllByDoctorToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleByUserToState(GetScheduleByUesr event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository.getScheduleByUser(event.idUser,day: event.fromDate != null ?  event.fromDate.millisecondsSinceEpoch : 0, toDay: event.toDate != null ? event.toDate.millisecondsSinceEpoch : 0, status: event.statusSchedule);
      if (data != null) {
        if (event.statusSchedule == StatusSchedule.New) {
          numberExamination = data.length;
        }
        yield FetchScheduleByUserSuccess(list: data, toDay: event.toDate?.millisecondsSinceEpoch ?? 0);
        print('_mapFetchScheduleByUserToState : ${data.length}');
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchScheduleByUserToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleByUserToState: $error');
    }
  }


  Stream<ScheduleState> _mapUpdateScheduleToState(UpdateSchedule event) async* {
    yield ScheduleLoading();
    final isSuccess = await scheduleRepository.updateStatusSchedule(event.idSchedule, event.statusSchedule);
    if (isSuccess != null && isSuccess == true) {
      yield UpdateScheduleSuccess();
    } else {
      yield ScheduleError();
    }
  }

  Stream<ScheduleState> _mapFetchScheduleLocalPushReminderToState(GetScheduleLocalPushReminder event) async* {
    yield LoadingLocalPushFetchSchedule();
    try {
      if (event.isDoctor) {
        final data = await scheduleRepository
            .getScheduleLocalPushReminderByDoctor(event.idUser,event.fromDate.millisecondsSinceEpoch);
        if (data != null) {
          yield FetchScheduleListenReminderPush(list: data);
          print('_mapFetchScheduleLocalPushReminderToState : ${data.length}');
        } else {
          yield ErrorFetchSchedule();
          print('error _mapFetchScheduleLocalPushReminderToState');
        }
      } else {
        final data = await scheduleRepository
            .getScheduleLocalPushReminderByUser(event.idUser,event.fromDate.millisecondsSinceEpoch);
        if (data != null) {
          yield FetchScheduleListenReminderPush(list: data);
          print('_mapFetchScheduleLocalPushReminderToState user : ${data.length}');
        } else {
          yield ErrorFetchSchedule();
          print('error _mapFetchScheduleLocalPushReminderToState');
        }
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushReminderToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleLocalPushNewByDoctorToState(GetScheduleLocalPushNewByDoctor event) async* {
    yield LoadingLocalPushFetchSchedule();
    try {
      scheduleRepository
          .getScheduleLocalPushNewByDoctor(event.idDoctor, event.fromDate.millisecondsSinceEpoch)
          .listen((event) {
        event.documentChanges.forEach((documentChange) {
          if (documentChange.type == DocumentChangeType.added) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState add ${item.id}');
            return add(GetScheduleLocalPushNewEventSuccess(item: item));
          } else if (documentChange.type == DocumentChangeType.modified) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState modified ${item.id}');
          } else if (documentChange.type == DocumentChangeType.removed) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState removed ${item.id}');
          }
        });
      });
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushNewByDoctorToState: $error');
    }
  }


  Stream<ScheduleState> _mapFetchScheduleLocalPushNewSuccessToState(GetScheduleLocalPushNewEventSuccess event) async* {
    try {
      yield FetchScheduleListenNewPush(item: event.item);
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushNewSuccessToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleLocalPushNewTotalSuccessToState(GetScheduleLocalPushNewEventSuccessTotal event) async* {
    try {
      print('_mapFetchScheduleLocalPushNewTotalSuccessToState');
      final data = await scheduleRepository.getScheduleLocalPushNewTotalByDoctor(event.idDoctor,event.fromDate.millisecondsSinceEpoch);
      if (data != null) {
        yield FetchScheduleListenNewPushTotal(total: data);
      } else {
        yield ErrorFetchSchedule();
        print('error _mapFetchScheduleLocalPushNewTotalSuccessToState');
      }
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushNewSuccessToState: $error');
    }
  }

  Stream<ScheduleState> _mapFetchScheduleLocalPushChangeStatusOfUserToState(GetScheduleLocalPushChangeStatusOfUser event) async* {
    yield LoadingLocalPushFetchSchedule();
    try {
      scheduleRepository
          .getScheduleLocalPushChangeStatusByUser(event.idUser, event.fromDate.millisecondsSinceEpoch)
          .listen((event) {
        event.documentChanges.forEach((documentChange) {
          if (documentChange.type == DocumentChangeType.added) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState add ${item.id}');
          } else if (documentChange.type == DocumentChangeType.modified) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState modified ${item.id}');
            return add(GetScheduleLocalPushChangeStatusOfUserEventSuccess(item: item));
          } else if (documentChange.type == DocumentChangeType.removed) {
            final item = ScheduleModel.fromSnapshot(documentChange.document);
            print('_mapFetchScheduleLocalPushNewByDoctorToState removed ${item.id}');
          }
        });
      });
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushNewByDoctorToState: $error');
    }
  }


  Stream<ScheduleState> _mapFetchScheduleLocalPushChangeStatusOfUserSuccessToState(GetScheduleLocalPushChangeStatusOfUserEventSuccess event) async* {
    try {
      yield FetchScheduleListenChangeStatusPushOfUser(item: event.item);
    } catch(error) {
      yield ErrorFetchSchedule();
      print('error _mapFetchScheduleLocalPushNewSuccessToState: $error');
    }
  }

}
