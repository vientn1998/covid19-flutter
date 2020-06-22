import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/location_model.dart';

class UserObj extends Equatable {
  String id = "";
  String name = "";
  String email = "";
  String avatar = "";
  String phone = "";
  String gender = "";
  String accessTokenFb = "";
  int birthday = 0;
  bool isDoctor = false, isVerifyPhone = false, isAuthFb;
  String timeline = "";
  LocationObj location;
  int yearExperience = 0;
  List<KeyValueObj> majors = [];
  List<String> imagesCertificate = [];
  String about = "";

  UserObj(
      {this.id,
      this.name,
      this.email,
      this.avatar,
      this.phone,
      this.gender,
      this.birthday,
      this.about,
      this.yearExperience,
      this.location,
      this.imagesCertificate,
      this.isDoctor,
      this.isAuthFb,
      this.accessTokenFb,
      this.majors, this.isVerifyPhone,
      this.timeline});

  UserObj copyWith(
      {String id,
      String name,
      String email,
      String avatar,
      String phone,
      String gender,
      int birthday}) {
    return UserObj(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
        phone: phone,
        gender: gender,
        birthday: birthday);
  }

  static UserObj fromJson(Map<String, Object> json) {
    return UserObj(
      id: json["id"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
      avatar: json["avatar"] as String,
      phone: json["phone"] as String,
      gender: json["gender"] as String,
      birthday: json["birthday"] as int,
      timeline: json["timeline"] as String,
      about: json["about"] as String,
      accessTokenFb: json["accessTokenFb"] as String,
      yearExperience: json["yearExperience"] as int,
      isDoctor: json["isDoctor"] as bool,
      isVerifyPhone: json["isVerifyPhone"] as bool,
      isAuthFb: json["isAuthFb"] as bool,
      majors: json["majors"] as List<KeyValueObj>,
      imagesCertificate: json["imagesCertificate"] as List<String>,
    );
  }

  static UserObj fromSnapshot(DocumentSnapshot snap) {
    return UserObj(
        id: snap.data['id'] ?? '',
        name: snap.data['name'],
        email: snap.data['email'] ?? '',
        phone: snap.data['phone'] ?? '',
        gender: snap.data['gender'] ?? '',
        birthday: snap.data['birthday'] ?? 0,
        avatar: snap.data['avatar'] ?? '',
        about: snap.data['about'] ?? '',
        accessTokenFb: snap.data['accessTokenFb'] ?? '',
        isAuthFb: snap.data['isAuthFb'] ?? false,
        timeline: snap.data['timeline'] ?? '',
        yearExperience: snap.data['yearExperience'] ?? 0,
        isDoctor: snap.data['isDoctor'] ?? false,
        isVerifyPhone: snap.data['isVerifyPhone'] ?? false,
        location: snap.data['location'] == null ? null : LocationObj.fromJson(snap.data['location']),
        imagesCertificate: snap.data['imagesCertificate'] != null ? List.from(snap.data['imagesCertificate']) : [],
        majors: snap.data['majors'] != null ? snap.data['majors'].map<KeyValueObj>((item) {
          return KeyValueObj.fromJson(item);
        }) : [],
    );

  }

  Map<String, Object> toJson() {
    if (majors != null && majors.length > 0) {
      print('majors $majors');
      final majorsList = majors.map((element) {
        return element.toJson();
      }).toList();
      print(location.toJson());
      print(majorsList);
      return {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "birthday": birthday,
        "avatar": avatar,
        "about": about,
        "timeline": timeline,
        "isDoctor": isDoctor,
        "isAuthFb": isAuthFb,
        "isVerifyPhone": isVerifyPhone,
        "accessTokenFb": accessTokenFb,
        "yearExperience": yearExperience,
        "location": location != null ? location.toJson() : null,
        "imagesCertificate": imagesCertificate,
        "majors": majorsList,
      };
    } else {
      print('majors $majors');
      return {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "birthday": birthday,
        "avatar": avatar,
        "about": about,
        "timeline": timeline,
        "accessTokenFb": accessTokenFb,
        "isAuthFb": isAuthFb,
        "isDoctor": isDoctor,
        "isVerifyPhone": isVerifyPhone,
        "yearExperience": yearExperience,
        "location": location != null ? location.toJson() : null,
        "imagesCertificate": imagesCertificate,
        "majors": null,

      };
    }

  }

  @override
  String toString() {
    // TODO: implement toString
    return 'User: id:$id name:$name phone:$phone email:$email '
        'avatar:$avatar gender:$gender birthday:$birthday isDoctor:$isDoctor isVerifyPhone:$isVerifyPhone timeline:$timeline '
        'yearExperience:$yearExperience isAuthFb: $isAuthFb accessTokenFb:$accessTokenFb location:$location imagesCertificate:$imagesCertificate majors:$majors)';
  }

  @override
  List<Object> get props =>
      [this.avatar, this.id, this.email, this.name, this.phone, this.email, this.isVerifyPhone];
}
