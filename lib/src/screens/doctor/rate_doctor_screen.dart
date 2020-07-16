import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/rate/rate_bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/widgets/button.dart';

class RateDoctorPage extends StatefulWidget {
  UserObj doctor;
  RateDoctorPage(this.doctor);
  @override
  _RateDoctorPageState createState() => _RateDoctorPageState();
}

class _RateDoctorPageState extends State<RateDoctorPage> {
  final heightAvatar = 100.0;
  var star = 0.0;
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
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
          if (state is LoadingCreateSchedule) {
            LoadingHud(context).show();
          } else if (state is ErrorCreateRate) {
            LoadingHud(context).dismiss();
          } else if (state is ExistsRate) {
            //show before rate
            LoadingHud(context).dismiss();
          } else if (state is CreateRateSuccess) {
            //back
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
                                children: [TextSpan(text: widget.doctor.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor))]
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightSpaceSmall,),
                          SmoothStarRating(
                            rating: star,
                            isReadOnly: false,
                            size: 40,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 1.0,
                            color: Colors.orange,
                            borderColor: Colors.grey,
                            onRated: (value) {
                              print("rating value -> $value");
                              star = value;
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 7),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(paddingDefault),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Submit Rate',
                    background: colorActive,
                    onPressed: star > 0 ? () {

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
    if (widget.doctor.avatar != null) {
      return CachedNetworkImage(
        imageUrl: widget.doctor.avatar,
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
