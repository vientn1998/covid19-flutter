
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/user_model.dart';

class RateModel extends Equatable {
  String id;
  int dateTime;
  UserObj user;
  String idOrder;
  String idDoctor;
  String idUser;
  String reason;
  int star;
  RateModel({this.id, this.dateTime, this.user, this.reason, this.idOrder, this.idDoctor, this.idUser, this.star});

  static RateModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    return RateModel(
      id: documentSnapshot.data['id'] ?? '',
      star: documentSnapshot.data['star'] ?? 0,
      dateTime: documentSnapshot.data['dateTime'] ?? 0,
      user: UserObj.fromJson(documentSnapshot.data['user']),
      idOrder: documentSnapshot.data['idOrder'] ?? '',
      idDoctor: documentSnapshot.data['idDoctor'] ?? '',
      idUser: documentSnapshot.data['idUser'] ?? '',
      reason: documentSnapshot.data['reason'] ?? '',
    );
  }

  Map<String, Object> toJson() {
    return {
      'id' : this.id,
      'idUser' : this.user.id,
      'idDoctor' : this.idDoctor,
      'dateTime' : this.dateTime,
      'user' : this.user.toJsonDoctor(),
      'idOrder' : this.idOrder,
      'reason' : this.reason,
      'star' : this.star,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id - idUser: $idUser - idDoctor $idDoctor - idOrder: $idOrder';
  }

  @override
  List<Object> get props => [this.id];
}