import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class UnInitialized extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState{
  UserObj userObj;
  Authenticated({@required this.userObj}) : assert(userObj != null);
  @override
  List<Object> get props => [];
}

class AuthenticateError extends AuthState {
  AuthenticateError();
}

class UnAuthenticated extends AuthState {
  UnAuthenticated();
}
