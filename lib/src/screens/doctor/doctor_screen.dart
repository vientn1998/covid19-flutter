import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_event.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_state.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/doctor/doctor_details_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/hex_color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/icon.dart';
import 'package:template_flutter/src/widgets/search_cus.dart';

import 'choose_schedule_screen.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {

  List<UserObj> listUser = [];

  @override
  void initState() {
    super.initState();
    print('initState');
    BlocProvider.of<DoctorBloc>(context).add(FetchListDoctor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<DoctorBloc,DoctorState>(
          listener: (context, state) {
            if (state is LoadingFetchDoctor) {
              return widgetSkeleton();
            }
            if (state is LoadErrorFetchDoctor) {
              DialogCus(context).show(message: "Error load doctor");
            }
            if (state is LoadSuccessFetchDoctor) {
              final list = state.list;
              print('LoadSuccessFetchDoctor ${list.length}');
              setState(() {
                listUser.addAll(list);
              });
            }
          },
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
                          icon: Icon(Icons.search,),
                          onPressed: () {

                          },
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: heightSpaceSmall,),
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
                    margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text('Categories', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)],
                    ),
                  ),
                  SizedBox(height: heightSpaceNormal,),
                  Container(
                    margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _buildCategories("Tim mạch, hô hấp", 'ic_cardiology', colorDeath),
                        ),
                        SizedBox(width: heightSpaceNormal,),
                        Expanded(
                          child: _buildCategories("Răng, hàm, mặt",'ic_tooth', colorTotalCase),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightSpaceNormal,),
                  Container(
                    margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _buildCategories("Tai, mũi, họng", 'ic_ear', colorActive),
                        ),
                        SizedBox(width: heightSpaceNormal,),
                        Expanded(
                          child: _buildCategories("See all",'', colorGoogle),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightSpaceNormal,),
                  Container(
                    margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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
                  ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listUser.length > 3 ? 3 : listUser.length,
                      separatorBuilder: (context, position) {
                        return SizedBox(height: paddingDefault - 5,);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _buildTopDoctor(listUser[index], () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => DoctorDetailsPage(userObj: listUser[index],),
                          ));
                        }, () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ScheduleDoctorPage(userObjReceiver: listUser[index],),
                          ));
                        });
                      }
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Near by', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                        Text('See all', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 240,
                    margin: EdgeInsets.only(right: paddingDefault - 7, left: paddingDefault - 7),
                    width: double.infinity,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: listUser.length,
                        separatorBuilder: (context, index) {
                          return Container(width: 0,);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return _buildNearByDoctor(listUser[index]);
                        }
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCategories(String name, String imageName, Color background, {Function function}) {
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
                child: imageName.length == 0 ? Icon(Icons.menu, size: 20, color: Colors.white,) : Image(
                  image: AssetImage('assets/images/$imageName.png'),
                  width: 20,
                  height: 20,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: background
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

  _buildTopDoctor(UserObj item, Function function, Function functionBook) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipOval(
                    child: _buildImageAvatar(item),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10,),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),),
                    SizedBox(height: 2,),
                    Text(item.getNameMajor(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                    SizedBox(height: 2,),
                    Text(item.location.address,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),),
                    Row(
                      children: <Widget>[
                        SmoothStarRating(
                          rating: 5,
                          isReadOnly: false,
                          size: 18,
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
                            fontSize: 13, color: textColor, fontWeight: FontWeight.w500
                        ),),
                        Spacer(),
                        Container(
                          height: 30,
                          width: 70,
                          child: OutlineButton(
                            child: Text('Book', style: TextStyle(
                                fontSize: 14, color: textColor
                            ),),
                            onPressed: functionBook,
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
      ),
      onTap: function,
    );
  }

  _buildNearByDoctor(UserObj item) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 7, left: 7, top: 10, bottom: 10),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipOval(
                      child: _buildImageAvatar(item),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              item.name,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2,),
            Text(item.getNameMajor(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
              overflow: TextOverflow.ellipsis, maxLines: 2,
            ),
            SizedBox(height: heightSpaceSmall,),
            Row(
              children: <Widget>[
                Icon(Icons.star, color: Colors.yellow, size: 18,),
                Text('4.5',style: TextStyle(
                    fontSize: 14, color: textColor, fontWeight: FontWeight.bold
                ),),
                Spacer(),
                Icon(Icons.location_on, color: Colors.grey, size: 18,),
                Text('2.4 km', style: TextStyle(
                    fontSize: 15, color: textColor, fontWeight: FontWeight.bold
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildImageAvatar(UserObj item) {
    if (item.avatar != null) {
      return CachedNetworkImage(
        imageUrl: item.avatar,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Center(
          child: FaIcon(FontAwesomeIcons.user),
        ),
      );
    } else {
      return Center(
        child: FaIcon(FontAwesomeIcons.user),
      );
    }
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
}
