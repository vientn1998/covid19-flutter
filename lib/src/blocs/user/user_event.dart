import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserCreate extends UserEvent {
  final UserObj userObj;
  final File file;
  final List<Asset> listAsset;
  UserCreate({@required this.userObj, this.file, this.listAsset}) : assert(userObj != null);
}

class CheckUserExists extends UserEvent {

  final String uuid;

  CheckUserExists({@required this.uuid}) : assert(uuid != null);
  @override
  List<Object> get props => [uuid];
}

class CheckPhoneExists extends UserEvent {

  final String phone;

  CheckPhoneExists({@required this.phone}) : assert(phone != null);
  @override
  List<Object> get props => [phone];
}


class GetDetailsUser extends UserEvent {
  GetDetailsUser();
}
