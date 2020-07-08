import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatGroupDay extends Equatable {

  int day = 0;
  List<ChatModel> listChat = [];

  ChatGroupDay({this.day, this.listChat});

  static ChatGroupDay fromSnapshot(DocumentSnapshot documentSnapshot) {
    List<ChatModel> list = [];
    if (documentSnapshot.data["listChat"] != null) {
      var ls = documentSnapshot.data["listChat"] as List;
      list.addAll(ls.map((item) => ChatModel.fromSnapshot(item)).toList());
    }
    return ChatGroupDay(
      day: documentSnapshot.data['day'] ?? 0,
      listChat: list,
    );
  }

  Map<String, Object> toJson() {
    final list = listChat.map((element) {
      return element.toJson();
    }).toList() ?? [];
    return {
      'dateTime' : this.day,
      'listChat': list
    };
  }


  @override
  List<Object> get props => [this.day];
}

class ChatModel extends Equatable {

  String id, idReceiver, idSender, content, url, type, idGroup, durationAudio;
  int day, dateTime;

  ChatModel({this.id, this.idReceiver, this.idSender, this.content, this.idGroup,this.url, this.dateTime, this.day, this.durationAudio, this.type});

  String get timerDuration => durationAudio != null && durationAudio.length > 0 ? durationAudio : '00:00';

  static ChatModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    return ChatModel(
      id: documentSnapshot.data['id'] ?? '',
      idReceiver: documentSnapshot.data['idReceiver'] ?? '',
      idSender: documentSnapshot.data['idSender'] ?? '',
      content: documentSnapshot.data['content'] ?? '',
      url: documentSnapshot.data['url'] ?? '',
      type: documentSnapshot.data['type'] ?? '',
      durationAudio: documentSnapshot.data['timeAudio'] ?? '',
      dateTime: documentSnapshot.data['dateTime'] ?? 0,
      day: documentSnapshot.data['day'] ?? 0,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id' : this.id,
      'idReceiver' : this.idReceiver,
      'idSender' : this.idSender,
      'content' : this.content,
      'url' : this.url,
      'type' : this.type,
      'timeAudio' : this.durationAudio,
      'day' : this.day,
      'dateTime' : this.dateTime,
    };
  }

  String getType(){
    if (content.isNotEmpty) {
      return 'text';
    }
    if (url.isNotEmpty) {
      return 'image';
    }
    return 'text';
  }

  @override
  List<Object> get props => [id];
}