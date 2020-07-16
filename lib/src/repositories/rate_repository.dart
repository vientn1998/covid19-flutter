import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/rate_model.dart';
import 'package:template_flutter/src/models/schedule_day_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import "package:collection/collection.dart";
import 'package:template_flutter/src/utils/define.dart';

class RateRepository {

  final rateCollection = Firestore.instance.collection("Rates");

  Future<RateModel> checkExist(String idOrder, String idUser) async {
    RateModel data;
    await rateCollection.where("idOder", isEqualTo: idOrder).where(
        "idUser", isEqualTo: idUser).getDocuments().then((value) {
      if (value.documents.length > 0) {
        data = RateModel.fromSnapshot(value.documents[0]);
      } else {
        data = null;
      }
    });
    return data;
  }

  Future<bool> createRate(RateModel rateModel) async {
    bool isSuccess = false;
    final id = rateCollection
        .document()
        .documentID;
    rateModel.id = id;
    final data = rateModel.toJson();
    print('createRate $data');
    await rateCollection.document(id).setData(data).then((value) {
      isSuccess = true;
    }, onError: (error) {
      print(error.toString());
      return false;
    });
    return isSuccess;
  }

  Future<List<RateModel>> getRateByDoctor({@required String idOrder,@required String idDoctor}) async {
    List<RateModel> listSchedule = [];
    print('getRateByDoctor $idOrder - $idDoctor');
    try {
      if (idOrder.isEmpty) {
        //get all by idDoctor
        await rateCollection
            .where("idDoctor", isEqualTo: idDoctor)
            .getDocuments()
            .then((querySnapshot) {
          final item = querySnapshot.documents.map((document) {
            return RateModel.fromSnapshot(document);
          }).toList();
          listSchedule.addAll(item);
        });
      } else {
        await rateCollection
            .where("idOrder", isEqualTo: idOrder)
            .where("idDoctor", isEqualTo: idDoctor)
            .getDocuments()
            .then((querySnapshot) {
          final item = querySnapshot.documents.map((document) {
            return RateModel.fromSnapshot(document);
          }).toList();
          listSchedule.addAll(item);
        });
      }
    } catch (error) {
      print('error getRateByDoctor : $error');
    }
    return listSchedule;
  }

}