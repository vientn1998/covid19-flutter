import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/key_value_model.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();
  @override
  List<Object> get props => [];
}

class InitDoctorEvent extends DoctorEvent {
}

class FetchListDoctor extends DoctorEvent {
  FetchListDoctor();
}

class FetchDoctorLoadMore extends DoctorEvent {
  bool isLoadMore = false;
  KeyValueObj major;
  FetchDoctorLoadMore({this.isLoadMore = false, this.major});
}