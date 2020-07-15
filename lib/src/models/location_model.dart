
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationObj {
  int id;
  double latitude = 0.0;
  double longitude = 0.0;
  double distance = 0.0;
  String street = '';
  String cityOrProvince = '';
  String country = '';
  String stressName = '';
  String wardOrDistrict = '';
  String address = '';
  LocationObj({this.latitude, this.longitude, this.street,this.cityOrProvince,
    this.country, this.stressName, this.wardOrDistrict, this.address});

  Map<String, Object> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "street": street,
      "cityOrProvince": cityOrProvince,
      "country": country,
      "stressName": stressName,
      "address": address,
      "wardOrDistrict": wardOrDistrict,
    };
  }


  String getFullAddress(Placemark placemark) {
    return '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subAdministrativeArea},'
        '${placemark.administrativeArea}, ${placemark.country}';
  }

  static LocationObj fromJson(Map<String, Object> json) {
    return LocationObj(
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double,
      street: json["street"] as String,
      cityOrProvince: json["cityOrProvince"] as String,
      country: json["country"] as String,
      stressName: json["stressName"] as String,
      address: json["address"] as String,
      wardOrDistrict: json["wardOrDistrict"] as String,
    );
  }

  static LocationObj fromSnapshot(DocumentSnapshot snap) {
    return LocationObj(
        latitude: snap.data['latitude'],
        longitude: snap.data['longitude'],
    );
  }

  @override
  String toString() {
    return '$address $latitude $longitude';
  }

}