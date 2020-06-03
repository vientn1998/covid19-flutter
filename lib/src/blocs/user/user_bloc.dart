import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import './bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  final UserRepository userRepository;
  UserBloc({@required this.userRepository}): assert(userRepository != null);
  StreamSubscription _usersSubscription;

  @override
  UserState get initialState => InitialUserState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserCreate) {
      yield* _mapCreateUserToState(event);
    } else if (event is GetDetailsUser) {
      yield* _mapGetDetailsUserToState();
    }
  }

  Stream<UserState> _mapCreateUserToState(UserCreate event) async* {
    yield UserCreateLoading();
    final isSuccess = await userRepository.addAccount(event.userObj);
    if (isSuccess != null && isSuccess == true) {
      yield UserCreateSuccess();
    } else {
      yield UserCreateError();
    }
  }

  Stream<UserState> _mapGetDetailsUserToState() async* {
    yield UserCreateLoading();
    userRepository.getListUser().listen((event) {
      print('length: ${event.length}');
      GetListUserSuccess(list: event);
    });
  }
}
