import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/widgets/button.dart';
import '../../utils/extension/int_extention.dart';
import '../../utils/extension/datetime_extention.dart';
class ScheduleDoctorPage extends StatefulWidget {

  final UserObj userObjReceiver;

  ScheduleDoctorPage({Key key,@required this.userObjReceiver}) : super(key: key);

  @override
  _ScheduleDoctorPageState createState() => new _ScheduleDoctorPageState();
}

class _ScheduleDoctorPageState extends State<ScheduleDoctorPage> {

  DateTime _currentDate = DateTime.now();
  DateTime dateTimeSelected = DateTime.now();
  UserObj userObjSender;
  KeyValueObj timeSelected;
  bool isShowDialog = false;
  static const double sizeIconWork = 9.0;

  static Widget _eventIcon = new Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(sizeIconWork / 2)),
        border: Border.all(color: Colors.blue, width: 1.0)),
    height: sizeIconWork,
    width: sizeIconWork,
  );

  CalendarCarousel _calendarCarouselNoHeader;

  EventList<Event> listMakeDate = EventList<Event>();
  List<KeyValueObj> listDataDefault = [
    KeyValueObj(id: 1, value: '07:00 - 08:00', timeBook: 7),
    KeyValueObj(id: 2, value: '08:00 - 09:00', timeBook: 8),
    KeyValueObj(id: 3, value: '09:00 - 10:00', timeBook: 9),
    KeyValueObj(id: 4, value: '10:00 - 11:00', timeBook: 10),
    KeyValueObj(id: 5, value: '11:00 - 12:00', timeBook: 11),
    KeyValueObj(id: 6, value: '13:00 - 14:00', timeBook: 13),
    KeyValueObj(id: 7, value: '14:00 - 15:00', timeBook: 14),
    KeyValueObj(id: 8, value: '15:00 - 16:00', timeBook: 15),
    KeyValueObj(id: 9, value: '16:00 - 17:00', timeBook: 16),
  ];

  List<ScheduleModel> listData = [];

  List<KeyValueObj> listDataValid = [];

  getUser() async {
    final data = UserObj.fromJson((await SharePreferences().getObject(SharePreferenceKey.user)));
    setState(() {
      userObjSender = data;
    });
  }

  getScheduleByDay(DateTime date) {
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleByDay(idDoctor: widget.userObjReceiver.id, date: date));
  }

  @override
  void initState() {
    isShowDialog = false;
    super.initState();
    getUser();
    final dateCurrent = DateTime.now();
    final dateInit = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
    dateTimeSelected = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
    listDataValid.addAll(listDataDefault);
    getScheduleByDay(dateInit);
    buildLoadAllSchedule();
  }

  buildLoadAllSchedule() {
    final dateCurrent = DateTime.now();
    final dateInit = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
    BlocProvider.of<ScheduleBloc>(context)
        .add(GetScheduleByDoctor(idDoctor: widget.userObjReceiver.id, fromDate: dateInit));
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.lightBlueAccent.withOpacity(0.5),
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      selectedDateTime: dateTimeSelected,
      selectedDayBorderColor: Colors.lightBlue,
      selectedDayButtonColor: Colors.lightBlueAccent.withOpacity(0.8),
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      todayButtonColor: Colors.black26,
      headerText: DateTimeUtils().formatMonthYearString(_currentDate),
      showHeader: true,
      isScrollable: false,
      daysHaveCircularBorder: true,

      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 15
      ),
      weekFormat: false,
      markedDatesMap: listMakeDate,
      height: 400.0,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      minSelectedDate: _currentDate.subtract(Duration(days: 1)),
      maxSelectedDate: _currentDate.add(Duration(days: 30)),
      onDayPressed: (dateTime,listEvent ) async {
        if (dateTime.difference(dateTimeSelected).inDays != 0 ) {
          setState(() {
            dateTimeSelected = dateTime;
          });
          getScheduleByDay(dateTime);
        }
      },
      daysTextStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
        fontSize: 15
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 14,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          setState(() {
            _currentDate = date;
          });
          print('on changed date $date');
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text(widget.userObjReceiver.name),
        ),
        body: BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleLoading) {
              LoadingHud(context).show();
              print('ScheduleLoading');
            } else if (state is ScheduleError) {
              LoadingHud(context).dismiss();
              DialogCus(context).show(message: 'Error when create schedule');
            } else if (state is CreateScheduleSuccess) {
              LoadingHud(context).dismiss();
              toast('Create schedule successfully', gravity: ToastGravity.BOTTOM);
              getScheduleByDay(state.dateTimeCreated);
              //buildLoadAllSchedule();
            } else if (state is LoadingFetchSchedule) {
              LoadingHud(context).show();
              print('LoadingFetchSchedule');
            } else if (state is ErrorFetchSchedule) {
              LoadingHud(context).dismiss();
              DialogCus(context).show(message: 'Error when fetch data schedule');
            } else if (state is FetchScheduleSuccess) {
              final data = state.list;
              print('FetchScheduleSuccess ${data.length}');
              listData.clear();
              data.sort((a, b) => a.id.compareTo(b.id));
              setState(() {
                listData.addAll(data);
              });
              listDataValid.clear();
              if (listData.length > 0) {
                listDataDefault.forEach((item) {
                  final schedule = data.firstWhere((element) => element.id == item.id.toString(), orElse: () => null);
                  print('schedule ${schedule.toString()}');
                  if (schedule == null || schedule.id.isEmpty) {
                    listDataValid.add(item);
                  }
                });
              } else {
                listDataValid.addAll(listDataDefault);
              }
              listDataValid.forEach((element) {
                print(element.toString());
              });
              LoadingHud(context).dismiss();
            } else if (state is FetchAllScheduleByDoctorSuccess) {
              final list = state.list;
              print('size FetchAllScheduleByDoctorSuccess ${list.length}');
              list.forEach((element) {
                setState(() {
                  listMakeDate.add(DateTime.fromMillisecondsSinceEpoch(element.dayTime), Event(
                    date: new DateTime(2020, 6, 26),
                    dot: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(sizeIconWork / 2)),
                        color: Colors.blue,
                      ),
                      height: sizeIconWork,
                      width: sizeIconWork,
                    ),
                  ));
                });
              });
              LoadingHud(context).dismiss();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: _calendarCarouselNoHeader,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text('List schedule', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),),
                  Spacer(),
                  FlatButton(
                    child: Text('Book', style: TextStyle(
                        fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),),
                    onPressed: () {
                      final currentDate = DateTime.now();
                      if (currentDate.hour > 16 && currentDate.day == dateTimeSelected.day
                          && currentDate.month == dateTimeSelected.month) {
                        toast('Time invalid, please choose next the day', gravity: ToastGravity.BOTTOM);
                        return;
                      }
                      final list = listDataValid.where((element) => element.timeBook > currentDate.hour);
                      print(list.length.toString());
                      print(listDataValid.length.toString());
                      if (currentDate.day == dateTimeSelected.day) {
                        if (listDataValid.isEmpty || list.length == 0){
                          toast('Book full', gravity: ToastGravity.BOTTOM);
                          return;
                        }
                      } else {
                        if (listDataValid.isEmpty){
                          toast('Book full', gravity: ToastGravity.BOTTOM);
                          return;
                        }
                      }
                      showDialogCreate(dateTimeSelected);
                    },
                  ),
                  SizedBox(width: 8,),
                ],
              ),
              Expanded(
                child: _buildItemSchedule(listData),
              )
              //
            ],
          ),
        )
    );
  }

  showDialogCreate(DateTime dateTimeCreate) async{
    final schedule = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return MyDialogCreateSchedule(dateTimeCreate,timeSelected,listDataValid,'', userObjSender, widget.userObjReceiver);
        }) as ScheduleModel;
    if (schedule != null && schedule.status.isNotEmpty) {
      BlocProvider.of<ScheduleBloc>(context).add(CreateSchedule(scheduleModel: schedule, dateTimeCreate: dateTimeCreate));
    }
  }

  _buildItemSchedule(List<ScheduleModel> list) {
    if (list.length == 0) {
      return Center(
       child: Text('Empty'),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          final item = list[index];
          return _buildTopDoctor(item);
        },
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        separatorBuilder: (context, index) => Container(height: 15,),
        itemCount: list.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  _buildTopDoctor(ScheduleModel item) {
    return Container(
      margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 1),
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(item.sender.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),),
                Spacer(),
                Text(int.parse(item.id).getTypeTimeSchedule(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),),
              ],
            ),
            SizedBox(height: 5,),
            Text(item.note.isEmpty ? 'N/a' : item.note, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: textColor),),
          ],
        ),
      ),
    );
  }
}

class MyDialogCreateSchedule extends StatefulWidget {

  final DateTime dateTime;
  KeyValueObj timeSelected;
  List<KeyValueObj> listData;
  String note;
  final UserObj userObjSender, userObjReceiver;
  MyDialogCreateSchedule(this.dateTime, this.timeSelected, this.listData, this.note, this.userObjSender, this.userObjReceiver);

  @override
  _MyDialogCreateScheduleState createState() => _MyDialogCreateScheduleState();
}

class _MyDialogCreateScheduleState extends State<MyDialogCreateSchedule> {

  String note;
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      elevation: 1,
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 35,),
                Expanded(
                  child: Text('Schedule', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor
                  ), textAlign: TextAlign.center,),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
              child: Row(
                children: <Widget>[
                  Text('Date:', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),),
                  SizedBox(width: heightSpaceSmall,),
                  Text(DateTimeUtils().formatDateString(widget.dateTime), style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),)
                ],
              ),
            ),
            SizedBox(height: heightSpaceNormal,),
            Padding(
              padding: const EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
              child: Row(
                children: <Widget>[
                  Text('Time:', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),),
                  SizedBox(width: heightSpaceSmall,),
                  Expanded(
                    child: InkWell(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: backgroundSearch,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1, color: backgroundTextInput)
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 6,),
                            Text(widget.timeSelected != null ? widget.timeSelected.value : 'Choose time', style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),),
                            Spacer(),
                            Icon(Icons.arrow_drop_down, color: colorIcon,)
                          ],
                        ),
                      ),
                      onTap: () async {
                        final currentDate = DateTime.now();
                        print('hour now ${currentDate}');
                        print('hour selected ${widget.dateTime}');
                        print('data  ${widget.listData.length}');
                        final List<KeyValueObj> list = [];
                        if (currentDate.hour > 16 && currentDate.day == widget.dateTime.day && currentDate.month == widget.dateTime.month) {
                          toast('Time invalid, please choose next the day', gravity: ToastGravity.BOTTOM);
                          return;
                        } else {
                          if (currentDate.day == widget.dateTime.day
                              && currentDate.month == widget.dateTime.month) {
                            widget.listData.forEach((element) {
                              if (element.timeBook > currentDate.hour) {
                                list.add(element);
                              }
                            });
                          } else {
                            list.addAll(widget.listData);
                          }
                        }
                        final time = await showDialog(
                          barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return MyDialogChooseTimeSchedule(list, widget.timeSelected);
                            }) as KeyValueObj;
                        print('time: $time');
                        setState(() {
                          widget.timeSelected = time;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: heightSpaceNormal,),
            Padding(
              padding: const EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Note:', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),),
                  SizedBox(width: heightSpaceSmall,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: backgroundSearch,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 1, color: backgroundTextInput)
                      ),
                      child: TextField(
                        maxLines: 3,
                        minLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        controller: textEditingController,
                        onChanged: (value) {
                          setState(() {
                            note = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 7),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height:5,),
            Container(
              margin: EdgeInsets.all(paddingDefault),
              height: heightButton,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: ButtonCustom(
                  title: 'Book',
                  background: colorActive,
                  onPressed: () async {
                    if (widget.timeSelected != null && widget.timeSelected.id != null) {
                      ScheduleModel obj = ScheduleModel();
                      obj.id = widget.timeSelected.id.toString();
                      obj.note = note;
                      obj.status = 'New';
                      obj.dateTime = widget.dateTime.millisecondsSinceEpoch;
                      obj.timeBook = widget.timeSelected.timeBook;
                      obj.sender = widget.userObjSender;
                      obj.receiver = widget.userObjReceiver;
                      print(widget.dateTime);
                      print(widget.timeSelected);
                      print(note);
                      Navigator.pop(context, obj);
                      FocusScope.of(context).unfocus();
                    } else {
                      toast('Please choose time');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MyDialogChooseTimeSchedule extends StatefulWidget {
  List<KeyValueObj> listData;
  KeyValueObj itemSelected;
  MyDialogChooseTimeSchedule(this.listData, this.itemSelected);

  @override
  _MyDialogSchedule createState() => _MyDialogSchedule();
}

class _MyDialogSchedule extends State<MyDialogChooseTimeSchedule> {

  String _currentTimeValue = '';
  KeyValueObj itemSelected;

  @override
  void initState() {
    _currentTimeValue = widget.itemSelected != null && widget.itemSelected.id != null ? widget.itemSelected.id.toString() : '';
    itemSelected = widget.itemSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Row(
        children: <Widget>[
          SizedBox(width: 30,),
          Expanded(
            child: Text('Choose time', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textColor
            ), textAlign: TextAlign.center,),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      titlePadding: EdgeInsets.only(top: 0, bottom: 0),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22)
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = widget.listData[index];
                    return ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            groupValue: _currentTimeValue,
                            value: item.id.toString(),
                            onChanged: (value) {
                              setState(() {
                                _currentTimeValue = item.id.toString();
                                itemSelected = item;
                              });
                            },
                          ),
                          Text(item.value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _currentTimeValue = item.id.toString();
                          itemSelected = item;
                        });
                      },
                    );
                  },
                  itemCount: widget.listData.length,
                  shrinkWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: heightSpaceLarge, left: heightSpaceLarge, bottom: 16, top: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 42,
                        child: FlatButton(
                          color: colorActive,
                          textColor: Colors.white,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                  style: BorderStyle.solid
                              )
                          ),
                          child: Text("Done", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),),
                          onPressed: () {
                            if (_currentTimeValue.length != 0) {
                              Navigator.pop(context, itemSelected);
                            } else {
                              toast('Please choose one item');
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}

