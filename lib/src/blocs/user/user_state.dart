import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class InitialUserState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserCheckExistsSuccess extends UserState {
  bool isExist = false;
  UserCheckExistsSuccess(this.isExist);
  @override
  List<Object> get props => [isExist];
}

class UserCheckExistsError extends UserState {}

class UserCreateLoading extends UserState {}

class UserCreateSuccess extends UserState {}

class UserCreateError extends UserState {}