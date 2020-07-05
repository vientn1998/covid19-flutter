import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
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
  static const heightFilter = 35.0;
  List<ScheduleModel> list = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  DateTime dateTimeSelected;
  StatusSchedule _statusSchedule;
  final dateNow = DateTime.now();
  DateTime dateCurrent;
  void _onRefresh() async{
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleByUesr(idUser: widget.userObj.id, fromDate: dateTimeSelected, statusSchedule: _statusSchedule));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    _refreshController.loadComplete();
    LoadingHud(context).dismiss();
  }


  @override
  void initState() {
    super.initState();
    dateTimeSelected = DateTime(dateNow.year, dateNow.month, dateNow.day);
    dateCurrent = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour);
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleByUesr(idUser: widget.userObj.id, fromDate: dateTimeSelected, statusSchedule: _statusSchedule));
    _tabController = new TabController(length: 2, vsync: this);
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
            new Tab(icon: new Icon(Icons.calendar_today, size: 20,)),
            new Tab(
              icon: new Icon(Icons.history, size: 20),
            )
          ],
          controller: _tabController,
        ),
        bottomOpacity: 1,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              if (state is LoadingFetchSchedule) {
                LoadingHud(context).show();
              } else if (state is ErrorFetchSchedule) {
                LoadingHud(context).dismiss();
                _onLoading();
              } else if (state is FetchScheduleByUserSuccess) {
                print('FetchScheduleByUserSuccess');

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
                _onLoading();
              }
            },
          )
        ],
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildWidgetCalendar(),
            buildWidgetHistory(),
          ],
          controller: _tabController,),
      ),
    );
  }

  buildWidgetCalendar() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(paddingDefault),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('List Upcoming ${list.length}', style: TextStyle(
                fontSize: 20,
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
                          child: const Text('Cancel', style: TextStyle(color: Colors.red),),
                          onPressed: () {
                            Navigator.pop(context);
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
                    print(status);
                    setState(() {
                      _statusSchedule = status;
                    });
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(GetScheduleByUesr(idUser: widget.userObj.id, fromDate: dateTimeSelected, statusSchedule: status));
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
                      : item.status == StatusSchedule.Approved.toShortString() ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildWidgetHistory() {
    return Center(child: Text("This is notification Tab View"));
  }

}