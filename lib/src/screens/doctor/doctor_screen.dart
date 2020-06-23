import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_event.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_state.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/hex_color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/icon.dart';
import 'package:template_flutter/src/widgets/search_cus.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DoctorBloc>(context).add(FetchListDoctor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
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
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: Colors.blue,),
                        onPressed: () {

                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            '',
                            style: kTitleBold,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red,),
                        onPressed: () {

                        },
                      )
                    ],
                  ),
                ),
                SearchCusWidget(hint: 'Search', isFocus: false ,onChange: (value) {

                },),
                SizedBox(height: heightSpaceLarge,),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170.0,
                    viewportFraction: 0.8,
                    enableInfiniteScroll: true,
//                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                  ),
                  items: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: HexColor("#E5EAFF"),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/ic_banner_one.png'),
                            width: 100,
                            height: 120,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Call your doctor',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HexColor(("#687FDF"))),
                              ),
                              SizedBox(height: heightSpaceSmall,),
                              Text('If you think you have been \nexposed to COVID-19.',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: HexColor(("#687FDF"))),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: HexColor("#687FDF"),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/ic_banner_two.png'),
                            width: 100,
                            height: 120,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Healthcare Professionals',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: heightSpaceSmall,),
                                Text('Do you have symptoms of Covid 19?', overflow: TextOverflow.clip,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: HexColor("#56549E"),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/ic_banner_three.png'),
                            width: 100,
                            height: 120,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Feel you have symptoms?',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: heightSpaceSmall,),
                                Text('Symptoms may appear \n2-14 days after exposure',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightSpaceNormal,),
                Container(
                  margin: EdgeInsets.only(right: paddingNavi, left: paddingNavi),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text('Categories', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)],
                  ),
                ),
                SizedBox(height: heightSpaceNormal,),
                Container(
                  margin: EdgeInsets.only(right: paddingNavi, left: paddingNavi),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _buildCategories("Head, eye, mouth, ear."),
                      ),
                      SizedBox(width: heightSpaceNormal,),
                      Expanded(
                        child: _buildCategories("Neck, hand, shoulder."),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightSpaceNormal,),
                Container(
                  margin: EdgeInsets.only(right: paddingNavi, left: paddingNavi),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _buildCategories("Arm, leg, stomach."),
                      ),
                      SizedBox(width: heightSpaceNormal,),
                      Expanded(
                        child: _buildCategories("See all"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightSpaceNormal,),
                Container(
                  margin: EdgeInsets.only(right: paddingNavi, left: paddingNavi),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Top doctor', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      Text('See all', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                BlocBuilder<DoctorBloc, DoctorState>(
                    builder: (context, state) {
                      if (state is LoadingFetchDoctor) {
                        print('LoadingFetchDoctor');
                        return Container();
                      }
                      if (state is LoadErrorFetchDoctor) {
                        print('LoadErrorFetchDoctor');
                        return Container();
                      }
                      if (state is LoadSuccessFetchDoctor) {
                        final list = state.list;
                        print('LoadSuccessFetchDoctor ${list.length}');
                        return Container();
                      }
                      return Container();
                    }
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCategories(String name, {Function function}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.favorite, color: Colors.white,),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange
              ),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor), overflow: TextOverflow.clip),
            )
          ],
        ),
      ),
    );
  }

  _buildTopDoctor(UserObj item) {
    return Container(
      margin: EdgeInsets.only(right: paddingNavi, left: paddingNavi),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: Icon(Icons.perm_identity),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Dr Ivan Smith', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),),
                  SizedBox(height: 2,),
                  Text('Head, eye, ear...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                  SizedBox(height: 2,),
                  Text('280 Xô Viết Nghệ Tĩnh, Quận Cẩm Lệ, Đà Nẵng.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),),
                  Row(
                    children: <Widget>[
                      SmoothStarRating(
                        rating: 5,
                        isReadOnly: false,
                        size: 20,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: true,
                        spacing: 1.0,
                        color: Colors.yellow,
                        borderColor: Colors.grey,
                        onRated: (value) {
                          print("rating value -> $value");
                        },
                      ),
                      Text('(100)',style: TextStyle(
                          fontSize: 14, color: textColor, fontWeight: FontWeight.w500
                      ),),
                      Spacer(),
                      Container(
                        height: 30,
                        width: 70,
                        child: OutlineButton(
                          child: Text('View', style: TextStyle(
                              fontSize: 14, color: textColor
                          ),),
                          onPressed: () {

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
