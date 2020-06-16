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

  Future<List<KeyValueObj>> getListMajor() async {
    List<KeyValueObj> list = [];
    await majorCollection.snapshots().listen((queySnapshot) {
      queySnapshot.documents.map((e) {
        print(e.documentID);
        list.add(KeyValueObj.fromDocument(e));
      }).toList();
    });
    print('object' + list.length.toString());
    return list;
  }
}