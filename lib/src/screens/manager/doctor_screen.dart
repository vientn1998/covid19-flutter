import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/covid19/country.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/manager/schedule_details_screen.dart';
import 'package:template_flutter/src/screens/home/search_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/icon.dart';
import '../../utils/extension/int_extention.dart';

class DoctorManagerPage extends StatefulWidget {
  @override
  _DoctorManagerPageState createState() => _DoctorManagerPageState();
}

class _DoctorManagerPageState extends State<DoctorManagerPage> {
  static const heightFilter = 35.0;
  List<ScheduleModel> list = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ScrollController listScrollController = ScrollController();
  DateTime dateTimeSelected, dateCurrent;
  StatusSchedule _statusSchedule = StatusSchedule.Today;
  UserObj userObj = UserObj();
  var numberToday = 0, numberCanceled = 0, numberNew = 0, numberApproved = 0;
  final dateNow = DateTime.now();
  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  getUser() async {
    final dataMap = await SharePreferences().getObject(SharePreferenceKey.user);
    if (dataMap != null) {
      final data = UserObj.fromJson(dataMap);
      if (data != null) {
        setState(() {
          userObj = data;
        });
      }
    }
    final dateCurrent = DateTime.now();
    dateTimeSelected = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleAllByDoctor(idDoctor: userObj.id, ));
  }

  @override
  void initState() {
    dateCurrent = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour);
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is LoadingFetchSchedule) {
                  LoadingHud(context).show();
                } else if (state is ErrorFetchSchedule) {
                  LoadingHud(context).dismiss();
                } else if (state is FetchAllScheduleByDoctorSuccess) {
                  final data = state.list;
                  data.sort((a, b) {
                    int cmp = a.dateTime.compareTo(b.dateTime);
                    if (cmp != 0) {
                      return cmp;
                    }
                    return a.timeBook.compareTo(b.timeBook);
                  });
                  list.clear();
                  if (_statusSchedule == StatusSchedule.New) {
                    final ls = data.where((element) {
                      var dateItem = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
                      print('${dateItem} - ${dateCurrent} ${element.timeBook} - ${dateCurrent.hour}');

                      print((dateItem.isAfter(dateCurrent)));

                      print((dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour));

                      return (dateItem.isAfter(dateCurrent))
                          || (dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour);
                    }).toList();
                    setState(() {
                      list.addAll(ls);
                    });
                  } else {
                    setState(() {
                      list.addAll(data);
                    });
                  }
                  LoadingHud(context).dismiss();
//                  scrollTop();

                } else if (state is FetchAllTotalScheduleByDoctorSuccess) {
                  final data = state.list;
                  print('datetimedatetime ${dateTimeSelected.millisecondsSinceEpoch}');
                  final today = data.where((element) => element.dateTime == dateTimeSelected.millisecondsSinceEpoch).toList().length;
                  final listNew = data.where((element) => element.status == StatusSchedule.New.toShortString()).toList();
                  final approved = data.where((element) => element.status == StatusSchedule.Approved.toShortString()).toList().length;
                  final canceled = data.where((element) => element.status == StatusSchedule.Canceled.toShortString()).toList().length;
                  final newCase = listNew.where((element) {
                    var dateItem = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
                    return (dateItem.isAfter(dateCurrent))
                        || (dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour);
                  }).toList().length;
                  setState(() {
                    numberToday = today;
                    numberCanceled = canceled;
                    numberNew = newCase;
                    numberApproved = approved;
                  });
                  BlocProvider.of<ScheduleBloc>(context)
                      .add(GetScheduleByDoctor(idDoctor: userObj.id, fromDate: dateTimeSelected, statusSchedule: null));
                  LoadingHud(context).dismiss();
                }
              },
            )
          ],
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: heightSpaceSmall,
                ),
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
                          toast("Coming soon", gravity: ToastGravity.BOTTOM);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            DateTimeUtils().formatDateString(DateTime.now()),
                            style: kTitleBold,
                          ),
                        ],
                      ),
                      IconBox(
                        iconData: Icons.search,
                        onPressed: () async {
                          toast("Coming soon", gravity: ToastGravity.BOTTOM);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: heightSpaceSmall,
                ),
                widgetBoxFilter(),
                Expanded(
                  child: buildListFilter(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildListFilter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(paddingDefault),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: "List today: ",
                    children: [
                      TextSpan(
                          text: '${list.length}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: heightFilter,
                  width: heightFilter,
                  child: Icon(Icons.sort),
                ),
                onTap: () async {
                  toast("Coming soon", gravity: ToastGravity.BOTTOM);
                  return;
                  final status = await showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                              child: const Text('New'),
                              onPressed: () async {
                                Navigator.pop(context, StatusSchedule.New);
                              }),
                          CupertinoActionSheetAction(
                              child: const Text('Approved'),
                              onPressed: () async {
                                Navigator.pop(context, StatusSchedule.Approved);
                              }),
                        ]),
                  ) as StatusSchedule;
                  if (status != null) {
                    print(status);
                    setState(() {
                      _statusSchedule = status;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: buildListView(),
          ),
        )
      ],
    );
  }

  buildListView() {
    if (list.isEmpty) {
      return Center(
        child: Text('Empty'),
      );
    }
    return ListView.separated(
      controller: listScrollController,
        itemBuilder: (context, index) {
          return buildItem(item: list[index], function: () async {
            final data = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => ScheduleDetails(scheduleModel: list[index],),
            )) as ScheduleModel;
            if (data != null) {
              if (data.status == StatusSchedule.Approved.toShortString()) {
                setState(() {
                  list.removeAt(index);
                  numberApproved += 1;
                  numberNew -= 1;
                });
              } else if (data.status == StatusSchedule.Canceled.toShortString()) {
                setState(() {
                  list.removeAt(index);
                  numberCanceled += 1;
                  numberNew -= 1;
                });
              } else if (data.status == StatusSchedule.Done.toShortString()) {
                setState(() {
                  list.removeAt(index);
                  numberApproved -= 1;
                });
              } else {
                setState(() {
                  list[index].status = data.status;
                });
              }
            }
          });
        },
        padding: EdgeInsets.only(top: 7, bottom: 10),
        separatorBuilder: (context, index) => Container(
              height: paddingDefault,
            ),
        itemCount: list.length);
  }

  buildItem({@required ScheduleModel item, Function function}) {
    return Container(
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
          ]),
      child: Material(
        child: InkWell(
          child: Padding(
            padding:
            const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${DateTimeUtils().formatDayString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue),
                        ),
                        Text(
                          '${DateTimeUtils().formatMonthString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hours: ${item.timeBook.getTypeTimeSchedule()}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${item.sender.name}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Phone: ${item.sender.phone != null ? item.sender.phone : 'N/a'}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 6,
                  height: 94,
                  decoration: BoxDecoration(
                      color: item.status == StatusSchedule.New.toShortString()
                          ? colorNew
                          : item.status ==
                          StatusSchedule.Approved.toShortString()
                          ? colorApproved
                          : item.status ==
                          StatusSchedule.Done.toShortString() ? colorDeath : colorCancel,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                ),
              ],
            ),
          ),
          onTap: function,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  widgetBoxStatus(
      Color background, String title, String value, Function function,
      {bool isCheck = false}) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: background),
      child: Material(
        child: InkWell(
          child: Row(
            children: <Widget>[
              Padding(
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
                          fontSize: 18),
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
              Spacer(),
              Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: isCheck ? Icon(
                        Icons.check,
                        size: 20,
                      ) : Icon(
                        Icons.check,
                        size: 20, color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          onTap: function,
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  scrollTop() {
    listScrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  widgetBoxFilter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              right: paddingDefault, left: paddingDefault),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetBoxStatus(colorSerious, 'Today', numberToday.toString(), () {
                    if (_statusSchedule == StatusSchedule.Today) {
                      return;
                    }
                    setState(() {
                      _statusSchedule = StatusSchedule.Today;
                    });
                    final dateCurrent = DateTime.now();
                    final date = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(GetScheduleByDoctor(idDoctor: userObj.id, fromDate: date, statusSchedule: null));
                  }, isCheck: _statusSchedule == StatusSchedule.Today),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child: widgetBoxStatus(colorCancel, 'Cancel', numberCanceled.toString(), () {
                    if (_statusSchedule == StatusSchedule.Canceled) {
                      return;
                    }
                    setState(() {
                      _statusSchedule = StatusSchedule.Canceled;
                    });
                    final dateCurrent = DateTime.now();
                    final date = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(GetScheduleByDoctor(idDoctor: userObj.id, fromDate: null, statusSchedule: StatusSchedule.Canceled));
                  }, isCheck: _statusSchedule == StatusSchedule.Canceled),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: paddingDefault,
        ),
        Padding(
          padding: const EdgeInsets.only(
              right: paddingDefault, left: paddingDefault),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widgetBoxStatus(colorNew, 'New', numberNew.toString(), () {
                    if (_statusSchedule == StatusSchedule.New) {
                      return;
                    }
                    setState(() {
                      _statusSchedule = StatusSchedule.New;
                    });
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(GetScheduleByDoctor(idDoctor: userObj.id, fromDate: null, statusSchedule: _statusSchedule));
                  }, isCheck: _statusSchedule == StatusSchedule.New),
                ),
                SizedBox(
                  width: paddingDefault,
                ),
                Flexible(
                  child:
                      widgetBoxStatus(colorApproved, 'Approved', numberApproved.toString(), () {
                        if (_statusSchedule == StatusSchedule.Approved) {
                          return;
                        }
                        setState(() {
                          _statusSchedule = StatusSchedule.Approved;
                        });
                        BlocProvider.of<ScheduleBloc>(context)
                            .add(GetScheduleByDoctor(idDoctor: userObj.id, fromDate: null, statusSchedule: _statusSchedule));
                      }, isCheck: _statusSchedule == StatusSchedule.Approved),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
