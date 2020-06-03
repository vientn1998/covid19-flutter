import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginEvent {
  final UserObj userObj;

  LoginSuccess({@required this.userObj}) : assert(userObj != null);
}

class LoginError extends LoginEvent {
  final String message;
  LoginError({@required this.message});
}
