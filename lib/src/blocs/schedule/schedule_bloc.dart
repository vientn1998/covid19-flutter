import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:template_flutter/src/repositories/schedule_repository.dart';
import 'bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  final ScheduleRepository scheduleRepository;

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
    } else if (event is GetScheduleByDoctor) {
      yield* _mapFetchDataByDoctorToState(event);
    } else {
      yield InitialScheduleState();
    }
  }

  Stream<ScheduleState> _mapCreateToState(CreateSchedule event) async* {
    yield ScheduleLoading();
    final isSuccess = await scheduleRepository.createSchedule(event.scheduleModel);
    if (isSuccess != null && isSuccess == true) {
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

  Stream<ScheduleState> _mapFetchDataByDoctorToState(GetScheduleByDoctor event) async* {
    yield LoadingFetchSchedule();
    try {
      final data = await scheduleRepository.getScheduleByDoctor(event.idDoctor);
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

}
