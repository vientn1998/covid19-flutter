import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();
  @override
  List<Object> get props => [];
}

class FetchListDoctor extends DoctorEvent {
  FetchListDoctor();
}
