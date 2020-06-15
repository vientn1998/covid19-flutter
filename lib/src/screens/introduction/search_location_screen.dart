import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/models/location_model.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/widgets/navigation_cus.dart';

class SearchLocationPage extends StatefulWidget {
  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  Covid19Dao covid19dao = Covid19Dao();
  checkPermission() async {
    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) {
      try {
        final Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
        if (position != null && position.latitude != null && position.latitude != null) {
          List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
          print('location device: ${placemark[0].toJson()}');
          final location = LocationObj(latitude: position.latitude, longitude: position.longitude,
              cityOrProvince: placemark[0].administrativeArea, country: placemark[0].country);
          covid19dao.insertLocation(location);
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

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      checkPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              NavigationCus(functionBack: () {
                Navigator.pop(context);
              }, functionRight: () {

              },),
              Expanded(
                child: Container(
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
