
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationObj {
  double latitude = 0.0;
  double longitude = 0.0;
  String cityOrProvince = '';
  String country = '';
  String stressName = '';
  String wardOrDistrict = '';
  LocationObj({this.latitude, this.longitude, this.cityOrProvince, this.country, this.stressName, this.wardOrDistrict});

  static LocationObj fromJson(Map<String, Object> json) {
    return LocationObj(
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double
    );
  }

  static LocationObj fromSnapshot(DocumentSnapshot snap) {
    return LocationObj(
        latitude: snap.data['latitude'],
        longitude: snap.data['longitude'],
    );
  }

  Map<String, Object> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude
    };
  }
}