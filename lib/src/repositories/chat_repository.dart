import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:template_flutter/src/models/chat_model.dart';

class ChatRepository {
  final chatCollection = Firestore.instance.collection("Chats");

  Future<bool> sendMessage(ChatModel chat) async {
    bool isSuccess = false;
    final collection = chat.idGroup;
    final id = chatCollection.document().documentID;
    chat.id = id;
    final data = chat.toJson();
    print('sendMessage $data');
    await chatCollection.document(collection).collection(collection).document(id).setData(data).then((value) {
      isSuccess = true;
    }, onError: (error) {
      print(error.toString());
      return false;
    });
    return isSuccess;
  }

  Stream<QuerySnapshot> getChatsRealmTimeById(String id) {
    return chatCollection.document(id).collection(id).limit(50).snapshots();
  }

  Future<List<ChatGroupDay>> getChatsById(String id) async {
    print('getChatsById : $id');
    List<ChatGroupDay> list = [];
    List<ChatModel> listChat = [];
    List<int> listDay = [];
    try {
      chatCollection.document(id).collection(id).orderBy("dateTime", descending: true).snapshots().listen((querySnapshot) {
        final item = querySnapshot.documentChanges.map((documentChange) {
          return ChatModel.fromSnapshot(documentChange.document);
        }).toList();
        listChat.addAll(item);
      });
      listChat.forEach((schedule) {
        if (!listDay.any((element) => element == schedule.day)) {
          listDay.add(schedule.day);
        }
      });
      print(listDay);
      Future.wait(listDay.map((item) async {
        final ls = listChat.where((element) {
          return item == element.day;
        }).toList();
        ls.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        var scheduleDay = ChatGroupDay(day: item, listChat: ls);
        list.add(scheduleDay);
      }));
    } catch (error) {
      print('error getChatsById : $error');
    }
    list.sort((a, b) => a.day.compareTo(b.day));
    return list;
  }

  Future<String> uploadImageToServer(String folder, File file) async {
    print('folder: $folder');
    String urlImage = "";
    String pathFolder = "Chats/" + folder + "/" + DateTime.now().toString() + ".jpg";
    try{
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      StorageReference storageReferenceProfilePic = firebaseStorage.ref();
      StorageReference imageRef = storageReferenceProfilePic.child(pathFolder);
      StorageUploadTask uploadTask = imageRef.putFile(file);
      await uploadTask.onComplete;

      await imageRef.getDownloadURL().then((fileURL) {
        print('File Uploaded $folder: $fileURL');
        urlImage = fileURL;
      });
      return urlImage;
    } catch (error) {
      print('exception upload');
      print(error);
      return "";
    }
  }

  Future<String> uploadFileChatToServer(String folder, File file) async {
    print('folder: $folder');
    String urlImage = "";
    String pathFolder = "Chats/" + folder + "/" + DateTime.now().toString();
    try{
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      StorageReference storageReferenceProfilePic = firebaseStorage.ref();
      StorageReference imageRef = storageReferenceProfilePic.child(pathFolder);
      StorageUploadTask uploadTask = imageRef.putFile(file);
      await uploadTask.onComplete;

      await imageRef.getDownloadURL().then((fileURL) {
        print('File Uploaded $folder: $fileURL');
        urlImage = fileURL;
      });
      return urlImage;
    } catch (error) {
      print('exception upload');
      print(error);
      return "";
    }
  }
}