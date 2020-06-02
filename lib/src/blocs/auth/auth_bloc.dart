import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:template_flutter/src/models/user_model.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthGooglePressed) {
      yield* _mapGoogleSignToState();
    }
  }

  Stream<AuthState> _mapGoogleSignToState() async* {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(authCredential);
    final FirebaseUser firebaseUser = authResult.user;
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
    if (currentUser.uid != null && currentUser.uid.isNotEmpty) {
      UserObj userObj = UserObj(id: currentUser.uid, name: currentUser.displayName, email: currentUser.email, avatar: currentUser.photoUrl);
      print(userObj.toString());
      yield AuthGoogleSuccess(userObj: userObj);
    } else {
      yield AuthGoogleError();
    }

  }


}
