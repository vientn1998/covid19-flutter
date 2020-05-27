import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/blocs/death/bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/models/covid19/country.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/screens/home/search_screen.dart';
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
  var countryName = "", countrySearch = "";

  List<Color> gradientColors = [
    HexColor("#9B95BA"),
    HexColor("#149889"),
  ];

  checkPermission() async {
    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) {
      final Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
      if (position != null && position.latitude != null && position.latitude != null) {
        List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
        print('location device: ${placemark[0].toJson()}');
        final country = BlocProvider.of<SearchBloc>(context).listCountry.firstWhere((item) => item.code != null && item.code.contains(placemark[0].isoCountryCode.toString()));
        setState(() {
          countryName = placemark[0].locality +", "+ placemark[0].country;
          isChooseCountry = true;
          countrySearch = country == null ? placemark[0].country : country.countrySearch;
        });
        BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview(countryName: countrySearch));
      } else {
        BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview());
        setState(() {
          isChooseCountry = false;
        });
      }
      BlocProvider.of<DeathBloc>(context).add(FetchAllDeaths());
    } else {
      //show dialog
      _showDialogDelete(context);
    }
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
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

                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          countryName,
                          style: kTitleBold,
                        ),
                      ],
                    ),
                    IconBox(
                      iconData: Icons.search,
                      onPressed: () async {
                        final item = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SearchPage()),
                        ) as CountryObj;
                        if (item != null) {
                          print('search return: ${item.countrySearch}');
                          setState(() {
                            isChooseCountry = true;
                            countrySearch = item.countrySearch;
                            countryName = item.countryName;
                          });
                          BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview(countryName: countrySearch));

                        }
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    right: paddingDefault, left: paddingDefault),
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
                              BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview(countryName: countrySearch));
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
                height: heightSpaceNormal,
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
              SizedBox(
                height: heightSpaceNormal,
              ),
              BlocBuilder<DeathBloc, DeathState>(
                builder: (context, state) {
                  if (state is Covid19LoadedDeaths) {
                    final list = state.list;
                    final data = list.map((e) => DeathsObj.clone(e)).toList().take(5);
                    return Container(
                      height: 300,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 24.0, top: 15.0, bottom: 0),
                        child: LineChart(
                          mainData(data),
                        ),
                      ),
                    );
                  }
                  if (state is Covid19DeathsLoading) {
                    return widgetLoadingChart();
                  }
                  return widgetLoadingChart();
                },
              ),
              SizedBox(
                height: heightSpaceLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData mainData(List<DeathsObj> data) {
    final dataSortByDeath = data.map((e) => DeathsObj.clone(e)).toList();
    dataSortByDeath.sort((a, b) => a.totalDeaths.compareTo(b.totalDeaths));
    dataSortByDeath.toList().forEach((element) {
      print(element.totalDeaths);
    });
    final maxLeft = dataSortByDeath[0].totalDeaths / dataSortByDeath[0].totalDeaths * 100;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.lightBlueAccent,
            strokeWidth: 0.2,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white30,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
          getTitles: (value) {
            return data[value.toInt()].date.toString();
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          getTitles: (value) {
            return dataSortByDeath[value.toInt()].totalDeaths.toString();
          },
          reservedSize: 20,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: Colors.grey, width: 0.5)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: data.length.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 3),
            FlSpot(6, 2),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,

          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.6)).toList(),
          ),
        ),
      ],
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
                  newCase ?? "0",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 17),
                ),
              ],
            ),
            Text(
              value.isEmpty ? "0" : value,
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
              const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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
              const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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

  widgetLoadingChart() {
    return Container(
      margin: EdgeInsets.all(paddingDefault),
      height: 300,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child:  SkeletonAnimation(
              child: Container(
                height: 290,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorSkeleton),
              ),
            ),
          ),
        ],
      ),
    );
  }

  widgetLoadData(OverviewObj data) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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
              const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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

//Row(
//mainAxisSize: MainAxisSize.min,
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//FlatButton(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(paddingDefault),
//),
//child: Text(
//'Total',
//style: TextStyle(
//fontWeight: (currentTab == StatusTabHome.total)
//? FontWeight.bold
//    : FontWeight.normal),
//),
//onPressed: () {
//setState(() {
//currentTab = StatusTabHome.total;
//});
//},
//),
//FlatButton(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(paddingDefault),
//),
//child: Text(
//'Today',
//style: TextStyle(
//fontWeight: (currentTab == StatusTabHome.today)
//? FontWeight.bold
//    : FontWeight.normal),
//),
//onPressed: () {
//setState(() {
//currentTab = StatusTabHome.today;
//});
//},
//),
//FlatButton(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(paddingDefault),
//),
//child: Text(
//'Yesterday',
//style: TextStyle(
//fontWeight: (currentTab == StatusTabHome.yesterday)
//? FontWeight.bold
//    : FontWeight.normal),
//),
//onPressed: () {
//setState(() {
//currentTab = StatusTabHome.yesterday;
//});
//},
//),
//],
//),