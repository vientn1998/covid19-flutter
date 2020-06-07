import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import './bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  final UserRepository userRepository;
  UserBloc({@required this.userRepository}): assert(userRepository != null);

  @override
  UserState get initialState => InitialUserState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserCreate) {
      yield* _mapCreateUserToState(event);
    } else if (event is CheckUserExists) {
      yield* _mapCheckExistUserToState(event);
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

  Stream<UserState> _mapCheckExistUserToState(CheckUserExists event) async* {
    yield UserLoading();
    final isSuccess = await userRepository.checkExist(event.uuid) as bool;
    if (isSuccess != null && isSuccess == true) {
      SharePreferences().saveString(SharePreferenceKey.uuid, event.uuid);
      yield UserCheckExistsSuccess(isSuccess);
    } else {
      yield UserCheckExistsError();
    }
  }
}
