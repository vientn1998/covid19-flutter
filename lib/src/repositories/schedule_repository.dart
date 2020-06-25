import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/src/models/schedule_model.dart';

class ScheduleRepository {

  final scheduleCollection = Firestore.instance.collection("Schedules");

  Future<bool> createSchedule(ScheduleModel scheduleModel) async {
    bool isSuccess = false;
    scheduleModel.id = '${scheduleModel.timeBook}';
    final data = scheduleModel.toJson();
    print('createSchedule $data');
    await scheduleCollection
        .document(scheduleModel.receiver.id)
        .collection('${scheduleModel.dateTime}')
        .document('${scheduleModel.timeBook}').setData(data).then(
            (value) {
          isSuccess = true;
        }, onError: (error) {
      print(error.toString());
      return false;
    });
    return isSuccess;
  }

  Future<List<ScheduleModel>> getScheduleByDoctorAndDay(String idDoctor, int day) async{
    List<ScheduleModel> list = [];
    try{
      await scheduleCollection.document(idDoctor).collection('$day}').getDocuments().then((querySnapshot){
        print('querySnapshot : ${querySnapshot.documents.length}');
        querySnapshot.documents.forEach((documentSnapshot) {
          list.add(ScheduleModel.fromSnapshot(documentSnapshot));
        });
      });
    } catch (error) {
      print('error getScheduleByDoctorAndDay : $error');
    }
    return list;
  }


}