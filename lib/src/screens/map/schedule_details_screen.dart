import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/widgets/button.dart';
import '../../utils/extension/int_extention.dart';
import '../../utils/extension/string_extention.dart';
class ScheduleDetails extends StatefulWidget {
  final ScheduleModel scheduleModel;
  ScheduleDetails({@required this.scheduleModel});
  @override
  _ScheduleDetailsState createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {

  static const double sizeIcon = 20.0;
  StatusSchedule _statusSchedule;


  updateSchedule(StatusSchedule statusSchedule) {
    BlocProvider.of<ScheduleBloc>(context)
        .add(UpdateSchedule(idSchedule: widget.scheduleModel.id, statusSchedule: statusSchedule));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Schedule'),
        centerTitle: true,
      ),
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleLoading) {
            LoadingHud(context).show();
            return;
          }
          if (state is ScheduleError) {
            LoadingHud(context).dismiss();
            return;
          }
          if (state is UpdateScheduleSuccess) {
            LoadingHud(context).dismiss();
            var result = widget.scheduleModel;
            result.status = _statusSchedule.toShortString();
            Navigator.pop(context, result);
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('Details user', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.perm_identity, size: sizeIcon, color: colorIcon,),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.name, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.phone, style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.getAddress(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('Details schedule', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.adjust, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.status, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(widget.scheduleModel.dateTime)), style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.timer, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.timeBook.getTypeTimeSchedule(), style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.mode_edit, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.note.stringValue(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('Details doctor', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.perm_identity, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.receiver.name, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.receiver.phone.stringValue(), style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.receiver.getAddress().stringValue(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.scheduleModel.status == StatusSchedule.New.toShortString()
              ? Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                      height: heightButton,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: ButtonCustom(
                          title: 'Cancel',
                          background: colorActive,
                          onPressed: () {
                            updateSchedule(StatusSchedule.Canceled);
                            setState(() {
                              _statusSchedule = StatusSchedule.Canceled;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: paddingDefault,),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                      height: heightButton,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: ButtonCustom(
                          title: 'Approve',
                          background: colorActive,
                          onPressed: () {
                            setState(() {
                              _statusSchedule = StatusSchedule.Approved;
                            });
                            updateSchedule(StatusSchedule.Approved);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ) :
              widget.scheduleModel.status == StatusSchedule.Approved.toShortString() ?
              Container(
                margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Done',
                    background: colorActive,
                    onPressed: () {
                      updateSchedule(StatusSchedule.Done);
                      setState(() {
                        _statusSchedule = StatusSchedule.Done;
                      });
                    },
                  ),
                ),
              ) : SizedBox(height: 1,)
            ],
          ),
        ),
      ),
    );
  }

  _buildBtnAction(IconData icon, Color background) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon, size: 20, color: Colors.white,),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: background
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
      return CachedNetworkImage(
        imageUrl : "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
        fit: BoxFit.cover,
      );
    }
  }
}
