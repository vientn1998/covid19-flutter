import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/hex_color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/icon.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double spaceBorder = 4;
  bool isChooseCountry = true;
  var currentTab = StatusTabHome.total;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<Covid19Bloc>(context).add(FetchDataOverview());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: heightSpaceLarge,),
            //notify and search
            Padding(
              padding: const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconBox(iconData: Icons.notifications_none,onPressed: () {
                    print('onPressed notify');
                  },),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text('Da Nang, Viet Nam', style: kTitleBold,),
                    ],
                  ),
                  IconBox(iconData: Icons.search,onPressed: () {
                    print('onPressed search');
                  },),
                ],
              ),
            ),
            SizedBox(height: heightSpaceLarge,),
            //menu
            Padding(
              padding: const EdgeInsets.only(right: paddingDefault, left: paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconMenuBox(iconData: Icons.report,background: colorTotalCase, title: 'Report',onPressed: () {

                  },),
                  IconMenuBox(iconData: Icons.next_week,background: colorDeath, title: 'Prevention',onPressed: () {

                  },),
                  IconMenuBox(iconData: Icons.camera_enhance,background: colorActive, title: 'Symptoms',onPressed: () {

                  },),IconMenuBox(iconData: Icons.tap_and_play,background: colorSerious, title: 'News',onPressed: () {

                  },),

                ],
              ),
            ),
            SizedBox(height: heightSpaceLarge,),
            //tab
            Padding(
              padding: const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
              child: Container(
                height: sizeBoxIcon,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorTab
                ),
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
                            print('o');
                            isChooseCountry = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: spaceBorder, left: spaceBorder, bottom: spaceBorder),
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isChooseCountry ? Colors.white : null
                          ),
                          child: Center(
                            child: Text('My Country', style: kBodyBold,),
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
                            print('global');
                            isChooseCountry = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: spaceBorder, right: spaceBorder, bottom: spaceBorder),
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isChooseCountry ? null : Colors.white
                          ),
                          child: Center(
                            child: Text('Global', style: kBodyBold,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0,),
            //today, total
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingDefault),
                  ),
                  child: Text('Total', style: TextStyle(
                      fontWeight: (currentTab == StatusTabHome.total) ? FontWeight.bold : FontWeight.normal
                  ),),
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
                  child: Text('Today', style: TextStyle(
                      fontWeight: (currentTab == StatusTabHome.today) ? FontWeight.bold : FontWeight.normal
                  ),),
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
                  child: Text('Yesterday', style: TextStyle(
                      fontWeight: (currentTab == StatusTabHome.yesterday) ? FontWeight.bold : FontWeight.normal
                  ),),
                  onPressed: () {
                    setState(() {
                      currentTab = StatusTabHome.yesterday;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 0,),
            //content
            BlocBuilder<Covid19Bloc,Covid19State>(
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

  widgetDeath(Color background, String title, String value) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: background
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16
            ),),
            Text(value, style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22
            ),),
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
          color: colorBackgroundSkeleton
      ),
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
          padding: const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetSkeleton(),
                ),
                SizedBox(width: paddingDefault,),
                Flexible(
                  child: widgetSkeleton(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: paddingDefault,),
        Padding(
          padding: const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetSkeleton(),
                ),
                SizedBox(width: paddingDefault,),
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
          padding: const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorTotalCase, 'TotalCase', data.totalCases),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(width: paddingDefault,),
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorSerious, 'Recovered', data.totalRecovered),
                    onTap: () {

                    },
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: paddingDefault,),
        Padding(
          padding: const EdgeInsets.only(right: paddingLarge, left: paddingLarge),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorActive, 'Active', data.activeCases),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(width: paddingDefault,),
                Flexible(
                  child: InkWell(
                    child: widgetDeath(colorDeath, 'Deaths', data.totalDeaths),
                    onTap: () {

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}