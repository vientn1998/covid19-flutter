import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserCreate extends UserEvent {
  final UserObj userObj;
  UserCreate({@required this.userObj}) : assert(userObj != null);
}

class GetDetailsUser extends UserEvent {
  GetDetailsUser();
}
