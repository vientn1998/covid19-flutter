import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import './bloc.dart';

class CommonBloc extends Bloc<CommonEvent, CommonState> {

  var overViewData = OverviewObj();

  @override
  CommonState get initialState => InitialCommonState();

  @override
  Stream<CommonState> mapEventToState(
    CommonEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
