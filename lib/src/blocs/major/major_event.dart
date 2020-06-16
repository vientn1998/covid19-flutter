import 'package:equatable/equatable.dart';

abstract class MajorEvent extends Equatable {
  const MajorEvent();
  @override
  List<Object> get props => [];
}

class FetchMajor extends MajorEvent {}
