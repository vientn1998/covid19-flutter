import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/src/models/key_value_model.dart';

class MajorRepository {

  final majorCollection = Firestore.instance.collection("Majors");

  Future<bool> addMajor(KeyValueObj keyValueObj) async {
    bool isSuccess = false;
    await majorCollection.document(keyValueObj.id.toString()).setData(keyValueObj.toJson()).then(
            (value) {
          isSuccess = true;
        }, onError: (error) {
      return false;
    });
    return isSuccess;
  }

  Future<QuerySnapshot> getListMajor() async {
    print('getListMajor');
    return await majorCollection.getDocuments();
  }
}