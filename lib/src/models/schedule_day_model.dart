import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

class ScheduleDayModel extends Equatable {

  int dayTime;
  List<ScheduleModel> listSchedule = [];

  ScheduleDayModel({this.dayTime, this.listSchedule});

  static ScheduleDayModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    List<ScheduleModel> list = [];
    if (documentSnapshot.data["ScheduleModel"] != null) {
      var ls = documentSnapshot.data["ScheduleModel"] as List;
      list.addAll(ls.map((item) => ScheduleModel.fromSnapshot(item)).toList());
    }
    return ScheduleDayModel(
      dayTime: documentSnapshot.data['dayTime'] ?? 0,
      listSchedule: list,
    );
  }

  Map<String, Object> toJson() {
    final list = listSchedule.map((element) {
      return element.toJson();
    }).toList() ?? [];
    return {
      'dayTime' : this.dayTime,
      'listSchedule': list
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'date: $dayTime - object:${listSchedule.length}';
  }

  @override
  List<Object> get props => [this.dayTime];
}