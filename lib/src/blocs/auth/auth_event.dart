import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthGooglePressed extends AuthEvent {
  AuthGooglePressed();
}

class AuthLogoutGoogle extends AuthEvent {
  AuthLogoutGoogle();
}
