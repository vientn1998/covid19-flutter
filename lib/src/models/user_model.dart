
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserObj extends Equatable {

  String id = "";
  String name = "";
  String email = "";
  String avatar = "";
  String phone = "";
  UserObj({this.id, this.name, this.email, this.avatar, this.phone});

  UserObj copyWith({String id, String name, String email, String avatar, String phone}) {
    return UserObj(id: id, name: name, email: email, avatar: avatar, phone: phone);
  }

  static UserObj fromJson(Map<String, Object> json) {
    return UserObj(
      id: json["id"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
      avatar: json["avatar"] as String,
      phone: json["phone"] as String,
    );
  }

  static UserObj fromSnapshot(DocumentSnapshot snap) {
    return UserObj(
        id: snap.data['id'],
        name: snap.data['name'],
        email: snap.data['email'],
        phone: snap.data['phone'],
        avatar: snap.data['avatar']
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "avatar": avatar,
    };
  }

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "avatar": avatar,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'User: $id $name $phone $email $avatar)';
  }

  @override
  List<Object> get props => [this.avatar, this.id, this.email, this.name, this.phone];
}