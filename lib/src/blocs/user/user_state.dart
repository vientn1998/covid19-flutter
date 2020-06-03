import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class InitialUserState extends UserState {
  @override
  List<Object> get props => [];
}

class UserCreateLoading extends UserState {

}

class UserCreateSuccess extends UserState {

}

class UserCreateError extends UserState {

}

class GetListUserSuccess extends UserState {
  List<UserObj> list;
  GetListUserSuccess({@required this.list});
}