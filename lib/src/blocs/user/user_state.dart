import 'package:equatable/equatable.dart';

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