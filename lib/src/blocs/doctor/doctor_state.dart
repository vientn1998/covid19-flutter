import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();
  @override
  List<Object> get props => [];
}

class InitialDoctorState extends DoctorState {
  @override
  List<Object> get props => [];
}


class LoadingFetchDoctor extends DoctorState {

}

class LoadErrorFetchDoctor extends DoctorState {

}

class LoadSuccessFetchDoctor extends DoctorState {
  List<UserObj> list;
  LoadSuccessFetchDoctor({@required this.list});
}