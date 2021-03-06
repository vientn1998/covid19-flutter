import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/rate/rate_bloc.dart';
import 'package:template_flutter/src/models/rate_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/widgets/button.dart';

class RateDoctorPage extends StatefulWidget {
  ScheduleModel scheduleModel;
  RateDoctorPage(this.scheduleModel);
  @override
  _RateDoctorPageState createState() => _RateDoctorPageState();
}

class _RateDoctorPageState extends State<RateDoctorPage> {
  final heightAvatar = 100.0;
  var star = 0.0;
  var isReadOnly = true;
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    star = 0;
    super.initState();
    fetData();

    print("_RateDoctorPageState ${widget.scheduleModel.toJson()}");
  }

  fetData() {
    BlocProvider.of<RateBloc>(context).add(FetchRate(idOrder: widget.scheduleModel.id));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rate Doctor'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: BlocListener<RateBloc, RateState>(
        listener: (context, state) {
          if (state is LoadingCreateSchedule || state is LoadingFetchRate) {
            LoadingHud(context).show();
          } else if (state is ErrorCreateRate) {
            LoadingHud(context).dismiss();
            toast(state.messageError);
          } else if (state is CreateRateSuccess) {
            //back
            LoadingHud(context).dismiss();
            toast("Submit rate successfully");
            Navigator.pop(context);
          } else if (state is FetchRateSuccess) {
            final data = state.list;
            if (data == null || data.length == 0) {
              //create
              setState(() {
                isReadOnly = false;
                star = 0.0;
              });
            } else {
              //view only
              final rate = data[0];
              setState(() {
                isReadOnly = true;
                star = rate.star.toDouble();
                textEditingController.text = rate.reason;
              });
              Timer(Duration(seconds: 1), () {
                print("star : $star");
                setState(() {
                  star = rate.star.toDouble();
                });
              });

            }
            LoadingHud(context).dismiss();
          }
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: heightSpaceLarge,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(heightAvatar / 2),
                            ),
                            height: heightAvatar,
                            width: heightAvatar,
                            child: Material(
                              child: ClipOval(
                                child: _buildImageAvatar(),
                              ),
                              elevation: 2,
                              borderRadius: BorderRadius.circular(heightAvatar / 2),
                            ),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          RichText(
                            text: TextSpan(
                                text: 'How was your experience \nwith ',
                                style: TextStyle(fontSize: 20, color: textColor),
                                children: [TextSpan(text: widget.scheduleModel.receiver.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor))]
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightSpaceSmall,),
                          SmoothStarRating(
                            rating: star,
                            isReadOnly: isReadOnly,
                            size: 40,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            allowHalfRating: false,
                            starCount: 5,
                            spacing: 1.0,
                            color: Colors.orange,
                            borderColor: Colors.grey,
                            onRated: (value) {
                              print("rating value -> $value");
                              setState(() {
                                star = value;
                              });
                            },
                          ),
                          SizedBox(height: heightSpaceSmall,),
                          Container(
                            margin: EdgeInsets.only(left: paddingNavi, right: paddingNavi),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Write a comment', style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                    fontWeight: FontWeight.w500
                                ),),
                                Text('Max 500 words', style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.w400
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: paddingNavi, right: paddingNavi, top: paddingSmall),
                            decoration: BoxDecoration(
                                color: backgroundSearch,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(width: 1, color: backgroundTextInput)
                            ),
                            child: TextField(
                              maxLines: 6,
                              minLines: 6,
                              maxLength: 500,
                              enabled: !isReadOnly,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: textColor
                              ),
                              controller: textEditingController,
                              onChanged: (value) {

                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              isReadOnly ? SizedBox(height: 0,): Container(
                margin: EdgeInsets.all(paddingDefault),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Submit Rate',
                    background: colorActive,
                    onPressed: star > 0 ? () {
                      var rate = RateModel();
                      rate.idOrder = widget.scheduleModel.id;
                      rate.dateTime = DateTime.now().millisecondsSinceEpoch;
                      rate.idDoctor = widget.scheduleModel.receiverId;
                      rate.idUser = widget.scheduleModel.senderId;
                      rate.star = star.toInt();
                      rate.reason = textEditingController.text;
                      rate.user = widget.scheduleModel.sender;
                      BlocProvider.of<RateBloc>(context).add(CreateRate(rateModel: rate));
                    } : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _buildImageAvatar() {
    if (widget.scheduleModel.receiver.avatar != null) {
      return CachedNetworkImage(
        imageUrl: widget.scheduleModel.receiver.avatar,
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
}
