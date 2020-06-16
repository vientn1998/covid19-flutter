import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/key_value_model.dart';

abstract class MajorState extends Equatable {
  const MajorState();
  @override
  List<Object> get props => [];
}

class InitialMajorState extends MajorState {
  @override
  List<Object> get props => [];
}

class LoadingMajor extends MajorState{}

class LoadedSuccessMajor extends MajorState {
  List<KeyValueObj> list;
  LoadedSuccessMajor({this.list});
}

class LoadedErrorMajor extends MajorState{}
