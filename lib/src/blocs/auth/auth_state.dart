import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthProgress extends AuthState {
  AuthProgress();
}

class AuthGoogleSuccess extends AuthState {
  UserObj userObj;
  AuthGoogleSuccess({@required this.userObj}) : assert(userObj != null);
}

class AuthGoogleError extends AuthState {
  String errorMessage = "";
  AuthGoogleError({this.errorMessage = ""});
}
