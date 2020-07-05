import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/screens/profile/medical_examination.dart';
import 'package:template_flutter/src/screens/profile/notification_screen.dart';
import 'package:template_flutter/src/services/notification_service.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserObj userObj = UserObj();
  String name;
  static const double heightPadding = 15.0;
  static const double sizeIcon = 18.0;
  List<ScheduleModel> listLocalPushReminder = [];
  List<ScheduleModel> listLocalPushNew = [];
  var totalScheduleNew = 0;
  var isFirstLoadStatusNew = false;
  @override
  void initState() {
    isFirstLoadStatusNew = false;
    super.initState();
    getUser();
  }

  getUser() async {
    final dataMap = await SharePreferences().getObject(SharePreferenceKey.user);
    if (dataMap != null) {
      final data = UserObj.fromJson(dataMap);
      if (data != null) {
        setState(() {
          userObj = data;
        });
        final dateCurrent = DateTime.now();
        final date = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
        BlocProvider.of<ScheduleBloc>(context)
            .add(GetScheduleLocalPushReminder(idUser: userObj.id, fromDate: date, isDoctor: userObj.isDoctor));
        if (userObj.isDoctor) {
          BlocProvider.of<ScheduleBloc>(context)
              .add(GetScheduleLocalPushNewEventSuccessTotal(idDoctor: userObj.id, fromDate: date));
          BlocProvider.of<ScheduleBloc>(context)
              .add(GetScheduleLocalPushNewByDoctor(idDoctor: userObj.id, fromDate: date));
        } else {
          BlocProvider.of<ScheduleBloc>(context)
              .add(GetScheduleLocalPushChangeStatusOfUser(idUser: userObj.id, fromDate: date));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build Profile');
    return Scaffold(
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is LoadingLocalPushFetchSchedule) {
            print('loading local push');
          } else if (state is ErrorFetchSchedule) {
            print('error fetch local push');
          } else if (state is FetchScheduleListenReminderPush) {
            print('total push reminder list ${state.list.length}');
            final dateNow = DateTime.now();
            final dateCurrent = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour);
            final data = state.list.where((element) {
              var dateItem = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
              return (dateItem.isAfter(dateCurrent))
                  || (dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour);
            }).toList();
            print('total push reminder data ${data.length}');
            var notificationPushLocal = NotificationPushLocal();
            notificationPushLocal.cancelAllNotifications();
            listLocalPushReminder.addAll(data);
            listLocalPushReminder.sort((a, b) {
              int cmp = a.dateTime.compareTo(b.dateTime);
              if (cmp != 0) {
                return cmp;
              }
              return a.timeBook.compareTo(b.timeBook);
            });
            if (userObj.isDoctor) {
              listLocalPushReminder.forEach((item) {
                try {
                  notificationPushLocal.scheduleNotificationDoctor(item);
                } catch (error) {
                  print(error);
                }
              });
            } else {
              listLocalPushReminder.forEach((item) {
                try {
                  notificationPushLocal.scheduleNotificationUser(item);
                } catch (error) {
                  print(error);
                }
              });
            }
          } else if (state is FetchScheduleListenNewPush) {
            final data = state.item;
            setState(() {
              listLocalPushNew.add(data);
            });
            print('FetchScheduleListenNewPush $totalScheduleNew - ${listLocalPushNew.length}');
            if (totalScheduleNew < listLocalPushNew.length) {
              var notificationPushLocal = NotificationPushLocal();
              notificationPushLocal.showNotificationAddSchedule(data);
            }
          } else if (state is FetchScheduleListenChangeStatusPushOfUser) {
            //change status schedule of user
            final data = state.item;
            print('FetchScheduleListenChangeStatusPushOfUser ${data.id}');
            var notificationPushLocal = NotificationPushLocal();
            notificationPushLocal.showNotificationChangeStatusOfUserSchedule(data);
          } else if (state is FetchScheduleListenNewPushTotal) {
            print('FetchScheduleListenNewPushTotal ${state.total}');
            setState(() {
              totalScheduleNew = state.total;
            });
          }
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: heightSpaceLarge,
                ),
                SizedBox(
                  height: heightSpaceNormal,
                ),
                _buildHeader(),
                SizedBox(
                  height: heightSpaceLarge,
                ),
                SizedBox(
                  height: heightSpaceSmall,
                ),
                _buildSection(_buildDataFirstSection()),
                SizedBox(
                  height: heightSpaceNormal,
                ),
                _buildSection(_buildDataSecondSection()),
                SizedBox(
                  height: heightSpaceNormal,
                ),
                _buildSection(_buildDataLogoutSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    final heightAvatar = 80.0;
    return Container(
      margin: EdgeInsets.only(left: paddingDefault, right: paddingDefault),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userObj.name != null ? userObj.name : 'N/a',
                style: kTitleWelcome,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Edit profile',
                style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          InkWell(
            child: Container(
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
            onTap: () async {},
          )
        ],
      ),
    );
  }

  _buildImageAvatar() {
    if (userObj.avatar != null) {
      return CachedNetworkImage(
        imageUrl: userObj.avatar,
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

  _buildSection(Widget widget) {
    return Container(
      margin: EdgeInsets.only(left: paddingDefault, right: paddingDefault),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: widget,
    );
  }

  _buildDataFirstSection() {
    final data = (BlocProvider.of<ScheduleBloc>(context).numberExamination);
    return Column(
      children: <Widget>[
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.briefcaseMedical,
              color: Colors.red,
              size: sizeIcon,
            ),
            "Medical examination",
            "${data}", function: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicalExamination(
                  userObj: userObj,
                ),
              ));
        }),
        _buildLine(),
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.bell,
              color: Colors.blueAccent,
              size: sizeIcon,
            ),
            "Notification",
            "", function: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ));
        }),
      ],
    );
  }

  _buildDataSecondSection() {
    return Column(
      children: <Widget>[
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.clipboardList,
              color: Colors.green,
              size: sizeIcon,
            ),
            "Visited address",
            "", function: () {
          print('Visited address');
        }),
        _buildLine(),
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.globeEurope,
              color: Colors.grey,
              size: sizeIcon,
            ),
            "Change language",
            "0", function: () {
          print('Change language');
        }),
        _buildLine(),
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.questionCircle,
              color: Colors.blueGrey,
              size: sizeIcon,
            ),
            "Support",
            "0", function: () {
          print('Support');
        }),
      ],
    );
  }

  _buildDataLogoutSection() {
    return Column(
      children: <Widget>[
        _buildRowItem(
            FaIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.blue,
              size: sizeIcon,
            ),
            "Logout",
            "0", function: () {
          print('Logout');
          DialogCus(context).showDialogs(
              message: 'Are you sure want to logout?',
              isDismiss: true,
              titleLef: 'Cancel',
              titleRight: 'Ok',
              funRight: () {
                logout();
              });
        }),
      ],
    );
  }

  _buildLine() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      margin: EdgeInsets.only(left: heightPadding, right: heightPadding),
    );
  }

  _buildRowItem(FaIcon icon, String title, String value, {Function function}) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(heightPadding, 10, 10, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Center(
                  child: icon,
                ),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(
                width: heightPadding,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Spacer(),
              Text(
                value == '0' ? '' : value,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              value == '0'
                  ? SizedBox()
                  : Icon(
                      Icons.navigate_next,
                      color: colorIcon,
                    ),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        onTap: function,
      ),
      color: Colors.transparent,
    );
  }

  logout() async {
    BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());
    await SharePreferences().saveBool(SharePreferenceKey.isLogged, false);
    await FacebookLogin().logOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }
}
