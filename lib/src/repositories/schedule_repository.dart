import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:template_flutter/src/models/schedule_day_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import "package:collection/collection.dart";
import 'package:template_flutter/src/utils/define.dart';

class ScheduleRepository {
  final scheduleCollection = Firestore.instance.collection("Schedules");
  List<DocumentSnapshot> documentList = [];
  Future<bool> createSchedule(ScheduleModel scheduleModel) async {
    bool isSuccess = false;
    final id = scheduleCollection.document().documentID;
    scheduleModel.id = id;
    final data = scheduleModel.toJson();
    print('createSchedule $data');
    await scheduleCollection.document(id).setData(data).then((value) {
      isSuccess = true;
    }, onError: (error) {
      print(error.toString());
      return false;
    });
    return isSuccess;
  }

  Future<List<DocumentSnapshot>> getScheduleFirst(List<DocumentSnapshot> list) async{
    print('getScheduleFirst ${list.length}');
    if (list.length == 0) {
      return ( await scheduleCollection.limit(10).orderBy("dateTime").getDocuments()).documents;
    } else {
      return ( await scheduleCollection.limit(10).orderBy("dateTime").startAfterDocument(list[list.length - 1]).getDocuments()).documents;
    }
  }

  Future<List<ScheduleModel>> getScheduleLoadFirst() async {
    List<ScheduleModel> list = [];
    try {
      print('documentList ${documentList.length}');
      if (documentList.length == 0) {
        await scheduleCollection
            .limit(10)
        .orderBy("dateTime")
            .getDocuments().then((querySnapshot) {
          documentList.addAll(querySnapshot.documents);
          final item = querySnapshot.documents.map((document) {
            return ScheduleModel.fromSnapshot(document);
          }).toList();
          list.addAll(item);
        });
      } else {
        await scheduleCollection
            .limit(10)
            .orderBy("dateTime")
        .startAfterDocument(documentList[documentList.length - 1])
            .getDocuments().then((querySnapshot) {
          documentList.addAll(querySnapshot.documents);
          final item = querySnapshot.documents.map((document) {
            return ScheduleModel.fromSnapshot(document);
          }).toList();
          list.addAll(item);
        });
      }
      print('getScheduleByDoctorAndDay list ${list.length}]');
    } catch (error) {
      print('error getScheduleByDoctorAndDay : $error');
    }
    return list;
  }

  Future<List<ScheduleModel>> getScheduleByDoctorAndDay(
      String idDoctor, int day) async {
    List<ScheduleModel> list = [];
    try {
      print('getScheduleByDoctorAndDay $idDoctor  - $day');
      await scheduleCollection
          .where("receiverId", isEqualTo: idDoctor)
          .where("dateTime", isEqualTo: day)
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        list.addAll(item);
      });
      print('getScheduleByDoctorAndDay list ${list.length}]');
    } catch (error) {
      print('error getScheduleByDoctorAndDay : $error');
    }
    return list;
  }

  Future<List<ScheduleDayModel>> getScheduleDayByDoctor(String idDoctor,
      {int day = 0, StatusSchedule status = StatusSchedule.New}) async {
    List<ScheduleDayModel> list = [];
    List<ScheduleModel> listSchedule = [];
    List<int> listDay = [];
    try {
      await scheduleCollection
          .where("receiverId", isEqualTo: idDoctor)
          .where("dateTime", isGreaterThanOrEqualTo: day)
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        listSchedule.addAll(item);
      });
      listSchedule.forEach((schedule) {
        if (!listDay.any((element) => element == schedule.dateTime)) {
          listDay.add(schedule.dateTime);
        }
      });
      print(listDay);
      Future.wait(listDay.map((item) async {
        final ls = listSchedule.where((element) {
          return item == element.dateTime;
        }).toList();
        var scheduleDay = ScheduleDayModel(dayTime: item, listSchedule: ls);
        list.add(scheduleDay);
      }));
    } catch (error) {
      print('error getScheduleByDoctor : $error');
    }
    return list;
  }

  Future<List<ScheduleModel>> getScheduleByDoctor(String idDoctor,
      {int day = 0, StatusSchedule status = StatusSchedule.New}) async {
    List<ScheduleModel> listSchedule = [];
    print('getScheduleByDoctor $idDoctor - $day - $status');
    try {
      if (day == 0) {
        if (status != null) {
          await scheduleCollection
              .where("receiverId", isEqualTo: idDoctor)
              .where("status", isEqualTo: status.toCastEnumIntoString())
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            listSchedule.addAll(item);
          });
        } else {
          await scheduleCollection
              .where("receiverId", isEqualTo: idDoctor)
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            listSchedule.addAll(item);
          });
        }
      } else {
        if (status != null) {
          if (status == StatusSchedule.History) {
            await scheduleCollection
                .where("receiverId", isEqualTo: idDoctor)
                .where("dateTime", isLessThan: day)
                .getDocuments()
                .then((querySnapshot) {
              final item = querySnapshot.documents.map((document) {
                return ScheduleModel.fromSnapshot(document);
              }).toList();
              listSchedule.addAll(item);
            });
          } else {
            await scheduleCollection
                .where("receiverId", isEqualTo: idDoctor)
                .where("status", isEqualTo: status.toCastEnumIntoString())
                .where("dateTime", isGreaterThanOrEqualTo: day)
                .getDocuments()
                .then((querySnapshot) {
              final item = querySnapshot.documents.map((document) {
                return ScheduleModel.fromSnapshot(document);
              }).toList();
              listSchedule.addAll(item);
            });
          }
        } else {
          await scheduleCollection
              .where("receiverId", isEqualTo: idDoctor)
              .where("dateTime", isEqualTo: day)
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            listSchedule.addAll(item);
          });
        }
      }
    } catch (error) {
      print('error getScheduleByDoctor : $error');
    }
    return listSchedule;
  }

  Future<List<ScheduleModel>> getScheduleAllByDoctor(String idDoctor) async {
    List<ScheduleModel> listSchedule = [];
    print('getScheduleAllByDoctor $idDoctor');
    try {
      await scheduleCollection
          .where("receiverId", isEqualTo: idDoctor)
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        listSchedule.addAll(item);
      });
    } catch (error) {
      print('error getScheduleByDoctor : $error');
    }
    return listSchedule;
  }

  Future<List<ScheduleModel>> getScheduleByUser(String idUser,
      {int day = 0, int toDay = 0, StatusSchedule status = StatusSchedule.New}) async {
    List<ScheduleModel> list = [];
    print('getScheduleByUser $idUser ${status.toCastEnumIntoString()} - $day - $toDay');
    try {
      if (status != null) {
        if (toDay > 0) {
          await scheduleCollection
              .where("senderId", isEqualTo: idUser)
              .where("dateTime", isLessThanOrEqualTo: toDay)
              .where("status", isEqualTo: status.toCastEnumIntoString())
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            list.addAll(item);
          });
        } else {
          await scheduleCollection
              .where("senderId", isEqualTo: idUser)
              .where("dateTime", isGreaterThanOrEqualTo: day)
              .where("status", isEqualTo: status.toCastEnumIntoString())
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            list.addAll(item);
          });
        }

      } else {
        if(toDay > 0) {
          await scheduleCollection
              .where("senderId", isEqualTo: idUser)
              .where("dateTime", isLessThan: toDay)
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            list.addAll(item);
          });
        } else {
          await scheduleCollection
              .where("senderId", isEqualTo: idUser)
              .where("dateTime", isGreaterThanOrEqualTo: day)
              .getDocuments()
              .then((querySnapshot) {
            final item = querySnapshot.documents.map((document) {
              return ScheduleModel.fromSnapshot(document);
            }).toList();
            list.addAll(item);
          });
        }

      }
    } catch (error) {
      print('error getScheduleByUser : $error');
    }
    return list;
  }

  Future<List<DocumentSnapshot>> getScheduleLoadMoreByUser(List<DocumentSnapshot> list, String idUser,
      {int day = 0, int toDay = 0, StatusSchedule status = StatusSchedule.New}) async {
    print('getScheduleByUser $idUser ${status.toCastEnumIntoString()} - $day - $toDay ${list.length}');
    try {
      if (list.length == 0) {
        if (status != null) {
          if (toDay > 0) {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isLessThan: toDay)
                .where("status", isEqualTo: status.toCastEnumIntoString()).limit(10).orderBy("dateTime")
                .getDocuments()).documents;
          } else {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isLessThan: day)
                .where("status", isEqualTo: status.toCastEnumIntoString()).limit(10).orderBy("dateTime")
                .getDocuments()).documents;
          }
        } else {
          if(toDay > 0) {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isLessThan: toDay).orderBy("dateTime").limit(10)
                .getDocuments()).documents;
          } else {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isGreaterThanOrEqualTo: day).limit(10).orderBy("dateTime")
                .getDocuments()).documents;
          }
        }
      } else {
        //load more
        if (status != null) {
          if (toDay > 0) {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isLessThanOrEqualTo: toDay)
                .where("status", isEqualTo: status.toCastEnumIntoString())
                .limit(10).orderBy("dateTime").startAfterDocument(list[list.length - 1])
                .getDocuments()).documents;
          } else {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isGreaterThanOrEqualTo: day)
                .where("status", isEqualTo: status.toCastEnumIntoString())
                .limit(10).orderBy("dateTime").startAfterDocument(list[list.length - 1])
                .getDocuments()).documents;
          }
        } else {
          if(toDay > 0) {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isLessThan: toDay).orderBy("dateTime")
                .limit(10).startAfterDocument(list[list.length - 1])
                .getDocuments()).documents;
          } else {
            return (await scheduleCollection
                .where("senderId", isEqualTo: idUser)
                .where("dateTime", isGreaterThanOrEqualTo: day)
                .limit(10).orderBy("dateTime").startAfterDocument(list[list.length - 1])
                .getDocuments()).documents;
          }
        }
      }

    } catch (error) {
      print('error getScheduleByUser : $error');
    }
    return list;
  }

  Future<List<ScheduleModel>> getScheduleLocalPushReminderByUser(
      String idUser, int day) async{
    List<ScheduleModel> list = [];
    print('getScheduleLocalPushReminderByUser : $idUser $day ${DateTime.now().hour}');
    try {
      await scheduleCollection
          .where("senderId", isEqualTo: idUser)
          .where("dateTime", isGreaterThanOrEqualTo: day)
          .where("status", isEqualTo: StatusSchedule.Approved.toCastEnumIntoString())
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        list.addAll(item);
      });
    }catch(error) {
      print('getScheduleLocalPushReminderByUser ${error}');
    }
    return list;
  }

  Future<List<ScheduleModel>> getScheduleLocalPushReminderByDoctor(
      String idUser, int day) async{
    List<ScheduleModel> list = [];
    print('getScheduleLocalPushReminderByUser : $idUser $day ${DateTime.now().hour}');
    try {
      await scheduleCollection
          .where("receiverId", isEqualTo: idUser)
          .where("dateTime", isGreaterThanOrEqualTo: day)
          .where("status", isEqualTo: StatusSchedule.Approved.toCastEnumIntoString())
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        list.addAll(item);
      });
    }catch(error) {
      print('getScheduleLocalPushReminderByDoctor ${error}');
    }
    return list;
  }

  Future<int> getScheduleLocalPushNewTotalByDoctor(
      String idDoctor, int day) async{
    List<ScheduleModel> list = [];
    print('getScheduleLocalPushNewTotalByDoctor : $idDoctor $day ${DateTime.now().hour}');
    try {
      await scheduleCollection
          .where("receiverId", isEqualTo: idDoctor)
          .where("dateTime", isGreaterThanOrEqualTo: day)
          .where("status", isEqualTo: StatusSchedule.New.toCastEnumIntoString())
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ScheduleModel.fromSnapshot(document);
        }).toList();
        list.addAll(item);
      });
    }catch(error) {
      print('getScheduleLocalPushReminderByDoctor ${error}');
    }
    return list.length;
  }

  Stream<QuerySnapshot> getScheduleLocalPushNewByDoctor(String idDoctor, int day) {
    print('getScheduleLocalPushNewByDoctor : $idDoctor $day');
    return scheduleCollection
        .where("receiverId", isEqualTo: idDoctor)
        .where("dateTime", isGreaterThanOrEqualTo: day)
        .where("status", isEqualTo: StatusSchedule.New.toCastEnumIntoString()).snapshots();
  }

  Stream<QuerySnapshot> getScheduleLocalPushChangeStatusByUser(String idDoctor, int day) {
    print('getScheduleLocalPushNewByDoctor : $idDoctor $day');
    return scheduleCollection
        .where("senderId", isEqualTo: idDoctor)
        .where("dateTime", isGreaterThanOrEqualTo: day).snapshots();
  }

  Future<bool> updateStatusSchedule(
      String id, StatusSchedule statusSchedule) async {
    bool isSuccess = false;
    print('updateStatusSchedule $statusSchedule');
    await scheduleCollection
        .document(id)
        .updateData({"status": statusSchedule.toCastEnumIntoString()}).then((value) {
      isSuccess = true;
    }, onError: (error) {
      print(error.toString());
      return false;
    });
    return isSuccess;
  }

  Future<ScheduleModel> getScheduleDetailsById({@required String id, @required String idDoctor}) async{
    ScheduleModel scheduleModel;
    print('getScheduleDetailsById : $id - idDoctor: $idDoctor');
    try {
      await scheduleCollection
          .where("id", isEqualTo: id).where("receiverId",isEqualTo: idDoctor)
          .getDocuments()
          .then((querySnapshot) {
            if (querySnapshot.documents.length > 0) {
              scheduleModel = ScheduleModel.fromSnapshot(querySnapshot.documents[0]);
            }
      });
    }catch(error) {
      print('getScheduleDetailsById ${error.toString()}');
    }
    return scheduleModel;
  }
}

//Future<List<ScheduleDayModel>> getScheduleByDoctor1(String idDoctor, int day) async {
//  List<ScheduleDayModel> list = [];
//  try{
//    List<DocumentSnapshot> listUser = await scheduleCollection.where("key",isEqualTo: idDoctor).getDocuments().then((value) => value.documents);
//    print('list ${listUser.length}');
//    await Future.wait(listUser.map((user) async {
//      print('element ${user.documentID}');
//      List<DocumentSnapshot> listDay = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).getDocuments().then((value) => value.documents);
//      await Future.wait(listDay.map((day) async {
//        print('day ${day.documentID}');
//        List<DocumentSnapshot> listHour = await scheduleCollection.document(user.documentID.toString()).collection(pathDay).document(day.documentID.toString()).collection(pathHours).getDocuments().then((value) => value.documents);
//        List<ScheduleModel> hours = [];
//        await Future.wait(listHour.map((element) async {
//          print('hours ${element.documentID}');
//          hours.add(ScheduleModel.fromSnapshot(element));
//        }));
//        var scheduleDay = ScheduleDayModel(dayTime: int.parse(day.documentID), listSchedule: hours);
//        list.add(scheduleDay);
//      }));
//    }));
//  } catch (error) {
//    print('error getScheduleByDoctor : $error');
//  }
//  return list;
//}
