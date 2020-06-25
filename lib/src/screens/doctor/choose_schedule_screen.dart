import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
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

class ScheduleDoctorPage extends StatefulWidget {

  final UserObj userObjReceiver;

  ScheduleDoctorPage({Key key,@required this.userObjReceiver}) : super(key: key);

  @override
  _ScheduleDoctorPageState createState() => new _ScheduleDoctorPageState();
}

class _ScheduleDoctorPageState extends State<ScheduleDoctorPage> {
  DateTime _currentDate;
  UserObj userObjSender;
  KeyValueObj timeSelected;
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 6, 26): [
        new Event(
          date: new DateTime(2020, 6, 26),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2020, 6, 26),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 6, 26),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarouselNoHeader;
  List<KeyValueObj> listDataDefault = [
    KeyValueObj(id: 0, value: '06:00 - 07:00', timeBook: 6),
    KeyValueObj(id: 1, value: '07:00 - 08:00', timeBook: 7),
    KeyValueObj(id: 2, value: '08:00 - 09:00', timeBook: 8),
    KeyValueObj(id: 3, value: '09:00 - 10:00', timeBook: 8),
    KeyValueObj(id: 4, value: '10:00 - 11:00', timeBook: 10),
    KeyValueObj(id: 5, value: '11:00 - 12:00', timeBook: 11),
    KeyValueObj(id: 6, value: '13:00 - 14:00', timeBook: 13),
    KeyValueObj(id: 7, value: '14:00 - 15:00', timeBook: 14),
    KeyValueObj(id: 8, value: '15:00 - 16:00', timeBook: 15),
    KeyValueObj(id: 9, value: '16:00 - 17:00', timeBook: 16),
  ];

  List<KeyValueObj> listData = [];

  getUser() async {
    final data = UserObj.fromJson((await SharePreferences().getObject(SharePreferenceKey.user)));
    setState(() {
      userObjSender = data;
    });
  }

  @override
  void initState() {
    _currentDate = DateTime.now();
    print('hour now ${_currentDate.hour}');
    listDataDefault.forEach((element) {
      if (element.timeBook > _currentDate.hour) {
        listData.add(element);
      }
    });

    getUser();
    _markedDateMap.add(
        new DateTime(2020, 6, 27),
        new Event(
          date: new DateTime(2020, 6, 27),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2020, 6, 28),
        new Event(
          date: new DateTime(2020, 6, 28),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2020, 6, 29), [
      new Event(
        date: new DateTime(2020, 6, 29),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2020, 6, 29),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2020, 6, 29),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.black54,
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      todayButtonColor: Colors.blueAccent,
      headerText: DateTimeUtils().formatMonthYearString(_currentDate),
      showHeader: true,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 15
      ),
      weekFormat: false,
//      markedDatesMap: _markedDateMap,
      height: 380.0,
//      weekDayBackgroundColor: Colors.red,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      minSelectedDate: _currentDate.subtract(Duration(days: 1)),
      maxSelectedDate: _currentDate.add(Duration(days: 30)),
      onDayPressed: (day,listEvent ) async {
        final schedule = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return MyDialogCreateSchedule(day,timeSelected,listData,'', userObjSender, widget.userObjReceiver);
            }) as ScheduleModel;
        if (schedule != null && schedule.status.isNotEmpty) {
          BlocProvider.of<ScheduleBloc>(context).add(CreateSchedule(scheduleModel: schedule));
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
        appBar: new AppBar(
          title: new Text(widget.userObjReceiver.name),
        ),
        body: BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleLoading) {
              LoadingHud(context).show();
            } else if (state is ScheduleError) {
              LoadingHud(context).dismiss();
            } else if (state is CreateScheduleSuccess) {
              LoadingHud(context).dismiss();
              toast('Create schedule successfully');
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(height: 500, color: Colors.red,),
                      Container(height: 500, color: Colors.yellow,),
                    ],
                  ),
                ),
              )
              //
            ],
          ),
        )
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
                        final time = await showDialog(
                          barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return MyDialogChooseTimeSchedule(widget.listData, widget.timeSelected);
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                  title: 'Create',
                  background: colorActive,
                  onPressed: () async {
                    if (widget.timeSelected != null && widget.timeSelected.id != null) {
                      ScheduleModel obj = ScheduleModel();
                      obj.note = note;
                      obj.status = 'New';
                      obj.dateTime = widget.dateTime.millisecondsSinceEpoch;
                      obj.timeBook = widget.timeSelected.id;
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

