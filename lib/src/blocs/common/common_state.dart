import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';

abstract class CommonState extends Equatable {
  const CommonState();
}

class InitialCommonState extends CommonState {
  @override
  List<Object> get props => [];
}

class DataCommon extends CommonState {

  @override
  List<Object> get props => [];
}
