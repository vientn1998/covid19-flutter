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
  }

  Stream<UserState> _mapCreateUserToState(UserCreate event) async* {
    print('data account ${event.userObj.toString()}');
    yield UserCreateLoading();
    if (event.file != null) {
      final urlAvatar = await userRepository.uploadFileToServer("avatar", event.file);
      event.userObj.avatar = urlAvatar;
      if (event.listAsset != null && event.listAsset.length > 0) {
        final imageCertificate = await userRepository.uploadMuliImagesAsset(event.listAsset);
        final images = imageCertificate.map((e) => e.toString());
        event.userObj.imagesCertificate.addAll(images);
      }
      final isSuccess = await userRepository.addAccount(event.userObj);
      if (isSuccess != null && isSuccess == true) {
        yield UserCreateSuccess();
      } else {
        yield UserCreateError();
      }
    } else {
      if (event.listAsset != null && event.listAsset.length > 0) {
        final imageCertificate = await userRepository.uploadMuliImagesAsset(event.listAsset);
        final images = imageCertificate.map((e) {
          return e.toString();
        });
        print('images: ${images.length}');
        event.userObj.imagesCertificate.addAll(images);
      }
      print('call addAccount');
      final isSuccess = await userRepository.addAccount(event.userObj);
      print('status create account $isSuccess');
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
  }
}
