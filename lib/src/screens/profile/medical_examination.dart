import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/doctor/rate_doctor_screen.dart';
import 'package:template_flutter/src/screens/manager/schedule_details_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import '../../utils/extension/int_extention.dart';
class MedicalExamination extends StatefulWidget {
  UserObj userObj;
  MedicalExamination({@required this.userObj});
  @override
  _MedicalExaminationState createState() => _MedicalExaminationState();
}

class _MedicalExaminationState extends State<MedicalExamination> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("My Examination Schedule"),
        centerTitle: true,
        bottom: TabBar(
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: paddingNavi),
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
          labelColor: Colors.white,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15
          ),
          unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          tabs: [
            Tab(icon: new Icon(Icons.calendar_today, size: 20,)),
            Tab(
              icon: new Icon(Icons.history, size: 20),
            )
          ],
          controller: _tabController,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListUpcoming(idUser: widget.userObj.id,),
            ListHistory(idUser: widget.userObj.id,)
          ],
          controller: _tabController,),
      );
  }

}

class ListUpcoming extends StatefulWidget {

  String idUser;

  ListUpcoming({Key key,this.idUser}): super(key: key);

  @override
  _ListUpcomingState createState() => _ListUpcomingState();
}

class _ListUpcomingState extends State<ListUpcoming> {

  static const heightFilter = 35.0;
  List<ScheduleModel> list = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  DateTime dateTimeSelected;
  StatusSchedule _statusSchedule;
  final dateNow = DateTime.now();
  DateTime dateCurrent;

  void _onRefresh() async{
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    dateTimeSelected = DateTime(dateNow.year, dateNow.month, dateNow.day);
    dateCurrent = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour);
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleByUesr(idUser: widget.idUser, fromDate: dateTimeSelected, statusSchedule: _statusSchedule));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScheduleBloc, ScheduleState>(
          listener: (ct, state) {
            if (state is LoadingFetchSchedule) {
//              LoadingHud(context).show();
            } else if (state is ErrorFetchSchedule) {
              LoadingHud(context).dismiss();
              _onLoading();
            } else if (state is FetchScheduleByUserSuccess) {
              final data = state.list.where((element) {
                var dateItem = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
                print('${dateItem} - ${dateCurrent} ${element.timeBook} - ${dateCurrent.hour}');

                print((dateItem.isAfter(dateCurrent)));

                print((dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour));

                return (dateItem.isAfter(dateCurrent))
                    || (dateItem.difference(dateCurrent).inDays == 0 && element.timeBook > dateCurrent.hour);
              }).toList();

              list.clear();
              data.sort((a, b) {
                int cmp = a.dateTime.compareTo(b.dateTime);
                if (cmp != 0) {
                  return cmp;
                }
                return a.timeBook.compareTo(b.timeBook);
              });
              setState(() {
                list.addAll(data);
              });
//              LoadingHud(ct).dismiss();
            }
          },
        )
      ],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(paddingDefault),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('List Upcoming: ${list.length}', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),),
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
                    final status = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true,
                            child: const Text('Clear', style: TextStyle(color: Colors.red),),
                            onPressed: () {
                              Navigator.pop(context, StatusSchedule.Clear);
                            },
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                                child: const Text('New'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.New);
                            }),
                            CupertinoActionSheetAction(
                                child: const Text('Approved'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.Approved);
                            }),
                          ]),
                    ) as StatusSchedule;
                    if (status != null) {
                      if (status == StatusSchedule.Clear) {
                        BlocProvider.of<ScheduleBloc>(context)
                            .add(GetScheduleByUesr(idUser: widget.idUser, fromDate: dateTimeSelected, statusSchedule: null));
                      } else {
                        print(status);
                        setState(() {
                          _statusSchedule = status;
                        });
                        BlocProvider.of<ScheduleBloc>(context)
                            .add(GetScheduleByUesr(idUser: widget.idUser, fromDate: dateTimeSelected, statusSchedule: status));
                      }
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
              child: buildListViewUpcoming(),
            ),
          )
        ],
      ),
    );
  }

  buildListViewUpcoming() {
    if (list.isEmpty) {
      return Center(child: Text('Empty'),);
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildUpcomingItem(item: list[index]);
        },
        padding: EdgeInsets.only(top: 7, bottom: 10),
        separatorBuilder: (context, index) => Container(height: paddingDefault,),
        itemCount: list.length
    );
  }

  buildUpcomingItem({@required ScheduleModel item}) {
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
          padding: const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 0),
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
                      Text('${DateTimeUtils().formatDayString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.blue),),
                      Text('${DateTimeUtils().formatMonthString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hours: ${item.timeBook.getTypeTimeSchedule()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),),
                    SizedBox(height: 4,),
                    Text('Doctor: ${item.receiver.name}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                    SizedBox(height: 8,),
                    Text('Address: ${item.receiver.location != null ? item.receiver.location.street : 'N/a' }',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor), overflow: TextOverflow.ellipsis, maxLines: 2,)
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 6,
                height: 94,
                decoration: BoxDecoration(
                    color: item.status == StatusSchedule.New.toShortString()
                        ? Colors.yellow
                        : item.status == StatusSchedule.Approved.toShortString() ? Colors.green : item.status == StatusSchedule.Done.toShortString() ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ScheduleDetails(scheduleModel: item,),
        ));
      },
    );
  }
}


class ListHistory extends StatefulWidget {

  String idUser;

  ListHistory({Key key,this.idUser}): super(key: key);

  @override
  _ListHistoryState createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
  static const heightFilter = 35.0;
  List<ScheduleModel> list = [];
  RefreshController _refreshController;
  DateTime dateTimeSelected;
  StatusSchedule _statusSchedule;
  final dateNow = DateTime.now();
  DateTime dateCurrent;

  void _onRefresh() async{
    list.clear();
    fetchData();
  }

  void _onLoading() async{
    loadingData();
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    dateTimeSelected = DateTime(dateNow.year, dateNow.month, dateNow.day);
    dateCurrent = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour);
    fetchData();
  }

  fetchData() {
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleLoadMoreByUesr(isLoadMore: false ,idUser: widget.idUser, toDate: dateTimeSelected, statusSchedule: _statusSchedule));
  }

  loadingData() {
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleLoadMoreByUesr(isLoadMore: true ,idUser: widget.idUser, toDate: dateTimeSelected, statusSchedule: _statusSchedule));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScheduleBloc, ScheduleState>(
          listener: (ct, state) {
            if (state is LoadingFetchSchedule) {
              LoadingHud(context).show();
            } else if (state is ErrorFetchSchedule) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
              LoadingHud(context).dismiss();
            } else if (state is FetchScheduleByUserSuccess) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
              LoadingHud(context).dismiss();
            }
          },
        )
      ],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(paddingDefault),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('List ${_statusSchedule == null ? 'history' : _statusSchedule.toShortString()}: ${list.length}', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),),
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
                    final status = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true,
                            child: const Text('Clear', style: TextStyle(color: Colors.red),),
                            onPressed: () {
                              Navigator.pop(context, StatusSchedule.Clear);
                            },
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                                child: const Text('New'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.New);
                            }),
                            CupertinoActionSheetAction(
                                child: const Text('Approved'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.Approved);
                            }),
                            CupertinoActionSheetAction(
                                child: const Text('Done'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.Done);
                            }),
                            CupertinoActionSheetAction(
                                child: const Text('Canceled'), onPressed: () async {
                              Navigator.pop(context, StatusSchedule.Canceled);
                            }),
                          ]),
                    ) as StatusSchedule;
                    if (status != null) {
                      if (status == StatusSchedule.Clear) {
                        BlocProvider.of<ScheduleBloc>(context)
                            .add(GetScheduleByUesr(idUser: widget.idUser, toDate: dateTimeSelected, statusSchedule: null));
                      } else {
                        print(status);
                        setState(() {
                          _statusSchedule = status;
                        });
                        BlocProvider.of<ScheduleBloc>(context)
                            .add(GetScheduleByUesr(idUser: widget.idUser, toDate: dateTimeSelected, statusSchedule: status));
                      }
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
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: Container(
                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is FetchScheduleByUserSuccess) {
                      final data = state.list.where((element) {
                        var dateItem = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
                        return (dateItem.isBefore(dateCurrent))
                            || (dateItem.difference(dateCurrent).inDays == 0 && element.timeBook < dateCurrent.hour);
                      }).toList();
                      data.sort((a, b) {
                        int cmp = b.dateTime.compareTo(a.dateTime);
                        if (cmp != 0) {
                          return cmp;
                        }
                        return b.timeBook.compareTo(a.timeBook);
                      });
                      print('list ${list.length}');
                      print('data ${data.length}');
                      list.addAll(data);
                      return buildListViewHistory(list);
                    } else if (state is LoadingFetchSchedule) {
                      return buildListViewHistory(list);
                    } else if (state is ErrorFetchSchedule) {
                      return Text('ErrorFetchSchedule...');
                    }
                    return Text('Loading');
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildListViewHistory(List<ScheduleModel> list) {
    print('buildListViewHistory ${list.length}');
    if (list.isEmpty) {
      return Center(child: Text('Empty'),);
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildHistoryItem(item: list[index]);
        },
//        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7, bottom: 10),
        separatorBuilder: (context, index) => Container(height: paddingDefault,),
        itemCount: list.length
    );
  }

  buildHistoryItem({@required ScheduleModel item}) {
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
          padding: const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 0),
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
                      Text('${DateTimeUtils().formatDayString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.blue),),
                      Text('${DateTimeUtils().formatMonthString(DateTime.fromMillisecondsSinceEpoch(item.dateTime))}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hours: ${item.timeBook.getTypeTimeSchedule()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),),
                    SizedBox(height: 4,),
                    Text('Doctor: ${item.receiver.name}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                    SizedBox(height: 8,),
                    Text('Address: ${item.receiver.location != null ? item.receiver.location.street : 'N/a' }',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor), overflow: TextOverflow.ellipsis, maxLines: 2,)
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 6,
                height: 94,
                decoration: BoxDecoration(
                    color: item.status == StatusSchedule.New.toShortString()
                        ? Colors.yellow
                        : item.status == StatusSchedule.Approved.toShortString() ? Colors.green : item.status == StatusSchedule.Done.toShortString() ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (item.status == StatusSchedule.Done.toShortString()) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => RateDoctorPage(item),
          ));
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ScheduleDetails(scheduleModel: item,),
          ));
        }
      },
    );
  }

}
