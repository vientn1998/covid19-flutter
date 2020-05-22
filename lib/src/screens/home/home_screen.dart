import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/services/permission_service.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/hex_color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/icon.dart';
import 'package:geolocator/geolocator.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double spaceBorder = 4;
  bool isChooseCountry = true;
  var currentTab = StatusTabHome.total;
  var countryName = "";

  checkPermission() async {
    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) {
      final Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        countryName = placemark[0].country;
      });
      print('----${placemark[0].country}');
      BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview(countryName: placemark[0].country));
    } else {
      //show dialog
      _showDialogDelete(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      checkPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: heightSpaceLarge,
            ),
            SizedBox(
              height: heightSpaceSmall,
            ),
            //notify and search
            Padding(
              padding: const EdgeInsets.only(
                  right: paddingDefault, left: paddingDefault),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconBox(
                    iconData: Icons.notifications_none,
                    onPressed: () {
                      print('onPressed notify');
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Da Nang, Viet Nam',
                        style: kTitleBold,
                      ),
                    ],
                  ),
                  IconBox(
                    iconData: Icons.search,
                    onPressed: () {
                      print('onPressed search');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightSpaceLarge,
            ),
            //menu
            Padding(
              padding: const EdgeInsets.only(
                  right: paddingDefault, left: paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconMenuBox(
                    iconData: Icons.report,
                    background: colorTotalCase,
                    title: 'Report',
                    onPressed: () {},
                  ),
                  IconMenuBox(
                    iconData: Icons.next_week,
                    background: colorDeath,
                    title: 'Prevention',
                    onPressed: () {},
                  ),
                  IconMenuBox(
                    iconData: Icons.camera_enhance,
                    background: colorActive,
                    title: 'Symptoms',
                    onPressed: () {},
                  ),
                  IconMenuBox(
                    iconData: Icons.tap_and_play,
                    background: colorSerious,
                    title: 'News',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightSpaceLarge,
            ),
            //tab
            Padding(
              padding: const EdgeInsets.only(
                  right: paddingLarge, left: paddingLarge),
              child: Container(
                height: sizeBoxIcon,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: colorTab),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isChooseCountry) {
                              return;
                            }
                            BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview(countryName: countryName));
                            isChooseCountry = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: spaceBorder,
                              left: spaceBorder,
                              bottom: spaceBorder),
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isChooseCountry ? Colors.white : null),
                          child: Center(
                            child: Text(
                              'My Country',
                              style: kBodyBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (!isChooseCountry) {
                              return;
                            }
                            BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview());
                            isChooseCountry = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: spaceBorder,
                              right: spaceBorder,
                              bottom: spaceBorder),
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isChooseCountry ? null : Colors.white),
                          child: Center(
                            child: Text(
                              'Global',
                              style: kBodyBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            //today, total
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingDefault),
                  ),
                  child: Text(
                    'Total',
                    style: TextStyle(
                        fontWeight: (currentTab == StatusTabHome.total)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  onPressed: () {
                    setState(() {
                      currentTab = StatusTabHome.total;
                    });
                  },
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingDefault),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                        fontWeight: (currentTab == StatusTabHome.today)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  onPressed: () {
                    setState(() {
                      currentTab = StatusTabHome.today;
                    });
                  },
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingDefault),
                  ),
                  child: Text(
                    'Yesterday',
                    style: TextStyle(
                        fontWeight: (currentTab == StatusTabHome.yesterday)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  onPressed: () {
                    setState(() {
                      currentTab = StatusTabHome.yesterday;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 0,
            ),
            //content
            BlocBuilder<Covid19Bloc, Covid19State>(
              builder: (context, state) {
                if (state is Covid19Loading) {
                  return widgetLoading();
                }
                if (state is Covid19LoadedOverview) {
                  final overview = state.overviewObj;
                  return widgetLoadData(overview);
                }
                return widgetLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  widgetDeath(Color background, String title, String value,{String newCase = ""}) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: background),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  newCase,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 17),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  widgetSkeleton() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorBackgroundSkeleton),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SkeletonAnimation(
              child: Container(
                height: 10,
                width: double.infinity / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorSkeleton),
              ),
            ),
            SkeletonAnimation(
              child: Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorSkeleton),
              ),
            ),
            SkeletonAnimation(
              child: Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorSkeleton),
              ),
            )
          ],
        ),
      ),
    );
  }

  widgetLoading() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetSkeleton(),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child: widgetSkeleton(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: paddingDefault,
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetSkeleton(),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child: widgetSkeleton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  widgetLoadData(OverviewObj data) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: InkWell(
                    child: widgetDeath(
                        colorTotalCase, 'TotalCase', data.totalCases,
                        newCase: data.newCases),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child: InkWell(
                    child: widgetDeath(
                        colorSerious, 'Recovered', data.totalRecovered),
                    onTap: () {},
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: paddingDefault,
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorActive, 'Active', data.activeCases),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorDeath, 'Deaths', data.totalDeaths,
                        newCase: data.newDeaths),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
//          contentPadding: EdgeInsets.symmetric(vertical: 16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      size: 100,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                    )
                  ],
                ),
                Text(
                  'Are you sure want to to leave this car?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'This action cannot be undone',
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          child: Text('next'),
                          onPressed: () {

                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          child: Text('close'),
                          onPressed: () {

                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _showDialogDelete(BuildContext context) {
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
                BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview());
              },
            ),
            CupertinoDialogAction(
              child: Text('Setting'),
              onPressed: () async {
                await AppSettings.openAppSettings();
//                if (await Permission.contacts.isGranted) {
//                  BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview());
//                }
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  _showActionMore(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(''),
            message: Text('Please select once the options below'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Update'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }
}
