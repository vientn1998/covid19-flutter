import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/src/models/schedule_day_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

class ScheduleRepository {

  final scheduleCollection = Firestore.instance.collection("Schedules");
  final pathDay = "Days";
  final pathHours = "Hours";

  Future<bool> createSchedule(ScheduleModel scheduleModel) async {
    bool isSuccess = false;
    final data = scheduleModel.toJson();
    print('createSchedule $data');
    await scheduleCollection
        .document(scheduleModel.receiver.id)
        .collection(pathDay)
        .document('${scheduleModel.dateTime}')
        .collection(pathHours)
        .document('${scheduleModel.timeBook}').setData(data).then(
            (value) {
          isSuccess = true;
        }, onError: (error) {
      print(error.toString());
      return false;
    });
    await scheduleCollection.document(scheduleModel.receiver.id).setData(
        {'key' : scheduleModel.receiver.id}).then((value) {
    });
    await scheduleCollection.document(scheduleModel.receiver.id).collection(pathDay).document(scheduleModel.dateTime.toString()).setData(
        {'key' : scheduleModel.dateTime}).then((value) {
    });
    return isSuccess;
  }

  Future<List<ScheduleModel>> getScheduleByDoctorAndDay(String idDoctor, int day) async{
    List<ScheduleModel> list = [];
    try{
      print('$idDoctor  - $day');
      await scheduleCollection
          .document(idDoctor)
          .collection(pathDay)
          .document(day.toString())
          .collection(pathHours)
          .getDocuments().then((querySnapshot){
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        list.addAll(item);
      });
    } catch (error) {
      print('error getScheduleByDoctorAndDay : $error');
    }
    return list;
  }

  Future<List<ScheduleDayModel>> getScheduleByDoctor(String idDoctor) async {
    List<ScheduleDayModel> list = [];
    try{
      List<DocumentSnapshot> listUser = await scheduleCollection.where("key",isEqualTo: idDoctor).getDocuments().then((value) => value.documents);
      print('list ${listUser.length}');
      await Future.wait(listUser.map((user) async {
        print('element ${user.documentID}');
        List<DocumentSnapshot> listDay = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).getDocuments().then((value) => value.documents);
        await Future.wait(listDay.map((day) async {
          print('day ${day.documentID}');
          List<DocumentSnapshot> listHour = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).document(day.documentID.toString()).collection(pathHours).getDocuments().then((value) => value.documents);
          List<ScheduleModel> hours = [];
          await Future.wait(listHour.map((element) async {
            print('hours ${element.documentID}');
            hours.add(ScheduleModel.fromSnapshot(element));
          }));
          var scheduleDay = ScheduleDayModel(dayTime: int.parse(day.documentID), listSchedule: hours);
          list.add(scheduleDay);
        }));
      }));
//      listUser.forEach((user) async {
//        print('element ${user.documentID}');
//        List<DocumentSnapshot> listDay = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).getDocuments().then((value) => value.documents);
//
//        await Future.wait(listDay.map((day) async {
//          print('day ${day.documentID}');
//        }));
//
//        listDay.forEach((day) async {
//          print('day ${day.documentID}');
//          List<DocumentSnapshot> listHour = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).document(day.documentID.toString()).collection(pathHours).getDocuments().then((value) => value.documents);
//          List<ScheduleModel> hours = [];
//          listHour.forEach((element) async{
//            print('hours ${element.documentID}');
//            hours.add(ScheduleModel.fromSnapshot(element));
//          });
//          var scheduleDay = ScheduleDayModel(dayTime: int.parse(day.documentID), listSchedule: hours);
//          list.add(scheduleDay);
//        });
//      });
    } catch (error) {
      print('error getScheduleByDoctor : $error');
    }
    return list;
  }

}