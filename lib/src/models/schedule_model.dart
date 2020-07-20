import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'user_model.dart';

class ScheduleModel extends Equatable {
  String id, receiverId, senderId;
  int timeBook;
  int dateTime;
  UserObj sender;
  UserObj receiver;
  String status;
  String note;
  DateTime dateTimeCreate;
  ScheduleModel({this.id, this.timeBook, this.dateTime, this.receiverId, this.senderId, this.sender, this.receiver, this.status, this.note, this.dateTimeCreate});

  static ScheduleModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    return ScheduleModel(
      id: documentSnapshot.data['id'] ?? '',
      timeBook: documentSnapshot.data['timeBook'] ?? 0,
      dateTime: documentSnapshot.data['dateTime'] ?? 0,
      sender: UserObj.fromJson(documentSnapshot.data['sender']),
      receiver: UserObj.fromJson(documentSnapshot.data['receiver']),
      status: documentSnapshot.data['status'] ?? '',
      note: documentSnapshot.data['note'] ?? '',
      receiverId: documentSnapshot.data['receiverId'] ?? '',
      senderId: documentSnapshot.data['senderId'] ?? '',
    );
  }

  Map<String, Object> toJson() {
    return {
      'id' : this.id,
      'receiverId' : this.receiver.id,
      'senderId' : this.sender.id,
      'timeBook' : this.timeBook,
      'dateTime' : this.dateTime,
      'sender' : this.sender.toJsonDoctor(),
      'receiver' : this.receiver.toJsonDoctor(),
      'status' : this.status,
      'note' : this.note,
    };
  }

  @override
  List<Object> get props => [this.id];
}