import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/rate_model.dart';
import 'package:template_flutter/src/repositories/rate_repository.dart';

part 'rate_event.dart';
part 'rate_state.dart';

class RateBloc extends Bloc<RateEvent, RateState> {

  final RateRepository repository;
  RateBloc(this.repository);

  @override
  RateState get initialState => RateInitial();

  @override
  Stream<RateState> mapEventToState(
    RateEvent event,
  ) async* {
    if (event is CreateRate) {
      yield* _mapCreateToState(event);
    } else if (event is FetchRate) {
      yield* _mapFetchRateToState(event);
    }
  }

  Stream<RateState> _mapCreateToState(CreateRate event) async* {
    yield LoadingCreateSchedule();
    print("_mapCreateToState ${event.rateModel.toString()}");
    try {
      final isSuccess = await repository.createRate(event.rateModel);
      if (isSuccess != null && isSuccess == true) {
        yield CreateRateSuccess();
      } else {
        yield ErrorCreateRate("Error submit rate");
      }
    }catch(error) {
      print(error);
      yield ErrorCreateRate(error.toString());
    }
  }

  Stream<RateState> _mapFetchRateToState(FetchRate event) async* {
    yield LoadingFetchRate();
    try {
      final data = await repository.getRateByDoctor(idOrder: event.idOrder, idDoctor: event.idDoctor);
      if (data != null) {
        yield FetchRateSuccess(list: data);
        print('_mapFetchRateToState : ${data.length}');
      } else {
        yield FetchRateSuccess(list: data);
        print('_mapFetchRateToState : not exists');
      }
    } catch(error) {
      yield ErrorFetchRate();
      print('error _mapFetchRateToState: $error');
    }
  }
}
