import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/models/location_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/navigation_cus.dart';
import 'package:template_flutter/src/widgets/search_cus.dart';

class SearchLocationPage extends StatefulWidget {
  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  Covid19Dao covid19dao = Covid19Dao();
  String stressValue = '', fullAddress = '';
  LocationObj _locationObj;
  checkPermission() async {
    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) {
      try {
        final Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
        if (position != null && position.latitude != null && position.latitude != null) {
          List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
          print('location device: ${placemark[0].toJson()}');

          final location = LocationObj(latitude: position.latitude, longitude: position.longitude,
              street: placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare,
              cityOrProvince: placemark[0].administrativeArea, country: placemark[0].country);
          final address = location.getFullAddress(placemark[0]);
          location.address = address;
          setState(() {
            _locationObj = location;
          });
          covid19dao.insertLocation(location);
          setState(() {
            stressValue = location.street;
            fullAddress = address;
          });
        } else {
          DialogCus(context).show(message: 'Please try again!');
        }

      }on Exception catch (exception) {
        DialogCus(context).show(message: 'Please try again!');
      }
    } else {
      _showDialogOpenSetting(context);
    }
  }

  _showDialogOpenSetting(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Covid19 App'),
          content: Text('\nPermission is denied\nPlease grand permission contact in setting'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
            CupertinoDialogAction(
              child: Text('Setting'),
              onPressed: () async {
                await AppSettings.openAppSettings();

                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  getLocation() async{
    final data = await covid19dao.getLocation();
    if (data != null && data.length > 0) {
      print('data ${data.toString()}');
      final item = data[0];
      setState(() {
        _locationObj = item;
        stressValue = item.street;
        fullAddress = item.address;
      });
    } else {
      print('have data');
      Timer(Duration(seconds: 1), () {
        checkPermission();
      });
    }


  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                NavigationCus(title: 'Search location ', isHidenIconRight: false,functionBack: () {
                  Navigator.pop(context);
                }, functionRight: () {

                },),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SearchCusWidget(hint: 'Find Address' ,onChange: (value) {

                      },),
                      SizedBox(height: 5,),
                      InkWell(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(paddingNavi),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.location_searching),
                                SizedBox(width: heightSpaceSmall,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(stressValue ?? '', style: kBodyBoldW600,),
                                    Text(fullAddress ?? '', style: kBody13,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, _locationObj);
                        },
                      ),
                      Expanded(
                        child: Container(
                          color: colorSkeleton,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
