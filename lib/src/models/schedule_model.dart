import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'user_model.dart';

class ScheduleModel extends Equatable {
  String id;
  int timeBook;
  int dateTime;
  UserObj sender;
  UserObj receiver;
  String status;
  String note;

  ScheduleModel({this.id, this.timeBook, this.dateTime, this.sender, this.receiver, this.status, this.note});

  static ScheduleModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    return ScheduleModel(
      id: documentSnapshot.data['id'] ?? '',
      timeBook: documentSnapshot.data['timeBook'] ?? 0,
      dateTime: documentSnapshot.data['dateTime'] ?? 0,
      sender: UserObj.fromJson(documentSnapshot.data['sender']),
      receiver: UserObj.fromJson(documentSnapshot.data['receiver']),
      status: documentSnapshot.data['status'] ?? '',
      note: documentSnapshot.data['note'] ?? '',
    );
  }

  Map<String, Object> toJson() {
    return {
      'id' : this.id,
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