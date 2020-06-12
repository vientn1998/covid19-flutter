import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import './bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository}) : assert(userRepository != null);
  StreamSubscription _usersSubscription;

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
//    else if (event is GetDetailsUser) {
//      yield* _mapGetDetailsUserToState();
//    }
  }

  Stream<UserState> _mapCreateUserToState(UserCreate event) async* {
    yield UserCreateLoading();
    if (event.file != null) {
      final urlAvatar = await userRepository.uploadFileToServer("avatar", event.file);
      event.userObj.avatar = urlAvatar;
      final isSuccess = await userRepository.addAccount(event.userObj);
      if (isSuccess != null && isSuccess == true) {
        yield UserCreateSuccess();
      } else {
        yield UserCreateError();
      }
    } else {
      final isSuccess = await userRepository.addAccount(event.userObj);
      if (isSuccess != null && isSuccess == true) {
        yield UserCreateSuccess();
      } else {
        yield UserCreateError();
      }
    }
  }

  Stream<UserState> _mapCheckExistUserToState(CheckUserExists event) async* {
    yield UserLoading();
    final isExists = await userRepository.checkExist(event.uuid);
    print('isExists: $isExists');
    SharePreferences().saveString(SharePreferenceKey.uuid, event.uuid);
    yield UserCheckExistsSuccess(isExists ?? false);

//  Stream<UserState> _mapGetDetailsUserToState() async* {
//    yield UserCreateLoading();
//    userRepository.getListUser().listen((event) {
//      print('length: ${event.length}');
//      GetListUserSuccess(list: event);
//    });
  }
}
