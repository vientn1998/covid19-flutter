import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<ChatGroupDay>> getChatsById(String id) async {
    print('getChatsById : $id');
    List<ChatGroupDay> list = [];
    List<ChatModel> listChat = [];
    List<int> listDay = [];
    try {
      await chatCollection.document(id).collection(id).orderBy("dateTime", descending: true)
          .getDocuments()
          .then((querySnapshot) {
        final item = querySnapshot.documents.map((document) {
          return ChatModel.fromSnapshot(document);
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
}