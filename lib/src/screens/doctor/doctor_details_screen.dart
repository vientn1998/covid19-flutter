import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/chat/chat_screen.dart';
import 'package:template_flutter/src/screens/doctor/choose_schedule_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/widgets/button.dart';

class DoctorDetailsPage extends StatefulWidget {
  final UserObj userObj;

  DoctorDetailsPage({@required this.userObj});

  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget.userObj.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: _buildImageAvatar(widget.userObj),
                    stretchModes: [StretchMode.zoomBackground],
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(widget.userObj)
                            ));
                      },
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.userObj.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          widget.userObj.getNameMajor(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildBtnAction(Icons.email, colorTotalCase),
                                  SizedBox(
                                    width: paddingDefault,
                                  ),
                                  _buildBtnAction(Icons.phone, background)
                                ],
                              ),
                              SizedBox(
                                height: paddingDefault,
                              ),
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
                                  Text(
                                    '(100 reviews)',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Text(
                                    'See all reviews',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Divider(),
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Text(
                                'About',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Text(
                                '${widget.userObj.name} is a respected expert in general health. He always want to learn...',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: backgroundSurvey),
                              ),
                              SizedBox(
                                height: paddingDefault,
                              ),
                              Text(
                                'Working hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Weekend 07:00 - 17:00',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey),
                                  ),
                                  SizedBox(
                                    width: paddingDefault,
                                  ),
                                  InkWell(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Open',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.lightBlue),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: borderColor.withOpacity(0.8)),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScheduleDoctorPage(
                                                  userObjReceiver: widget.userObj,
                                                ),
                                          ));
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                height: heightSpaceSmall,
                              ),
                              Text(
                                widget.userObj.location.address,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: backgroundSurvey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(paddingDefault),
            height: heightButton,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
              child: ButtonCustom(
                title: 'Book',
                background: colorActive,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScheduleDoctorPage(
                              userObjReceiver: widget.userObj,
                            ),
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBtnAction(IconData icon, Color background) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: background),
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
      return CachedNetworkImage(
        imageUrl:
            "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
        fit: BoxFit.cover,
      );
    }
  }
}

class SliverAppBarTab extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  SliverAppBarTab({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: expandedHeight,
      width: double.infinity,
      color: Colors.deepOrangeAccent,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[Text('Infor'), Text('Timeline')],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          fit: BoxFit.cover,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
