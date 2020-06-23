import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import './bloc.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {

  final UserRepository userRepository;

  DoctorBloc({@required this.userRepository});

  @override
  DoctorState get initialState => InitialDoctorState();

  @override
  Stream<DoctorState> mapEventToState(
    DoctorEvent event,
  ) async* {
    if (event is FetchListDoctor) {
      yield* _mapDoctorsToState(event);
    }
  }

  Stream<DoctorState> _mapDoctorsToState(FetchListDoctor event) async* {
    yield LoadingFetchDoctor();
    final list = await userRepository.getListDoctor();
    if (list != null) {
      yield LoadSuccessFetchDoctor(list: list);
    } else {
      yield LoadErrorFetchDoctor();
    }
  }
}
