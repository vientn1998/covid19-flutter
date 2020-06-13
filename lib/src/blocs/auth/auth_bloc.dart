import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  UserRepository userRepository;
  UserObj _userObj;

  AuthBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  AuthState get initialState => UnInitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthGooglePressed) {
      yield* _mapGoogleSignToState();
    } else if (event is AuthLogoutGoogle) {
      userRepository.signOut();
    }
  }

  Stream<AuthState> _mapGoogleSignToState() async* {
    final user = await userRepository.signWithGoogle();
    if (user.uid != null && user.uid.isNotEmpty) {
      UserObj userObj = UserObj(
          id: user.uid,
          name: user.displayName,
          email: user.email,
          avatar: user.photoUrl);
      print(userObj.toString());
      _userObj = userObj;
      yield Authenticated(userObj: userObj);
    } else {
      yield AuthenticateError();
    }
  }

  Stream<AuthState> _mapSignOutToState() async* {
    await userRepository.isSignedIn();
    yield UnAuthenticated();
  }
}
