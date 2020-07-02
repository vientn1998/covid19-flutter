import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import '../utils/extension/int_extention.dart';
class NotificationPushLocal {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final NotificationPushLocal _singleton = NotificationPushLocal._internal();

  factory NotificationPushLocal() {
    return _singleton;
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> scheduleNotificationUser(ScheduleModel scheduleModel) async {
    var scheduledNotificationDateTime = DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime)
        .add(Duration(minutes: scheduleModel.timeBook * 60 - 17));
//    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var message = BigTextStyleInformation(
        'Bạn có cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc <b>${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}</b>',
      htmlFormatSummaryText: true,
      htmlFormatBigText: true
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id',
        'name',
        'description',
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
//      styleInformation: message
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook,
        'Nhắc nhở lịch khám bệnh',
        'Bạn có cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'abc'
    );
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future<void> showNotificationWithCustomTimestamp() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showDailyAtTime() async {
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  Future<void> showWeeklyAtDayAndTime() async {
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        Day.Monday,
        time,
        platformChannelSpecifics);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  NotificationPushLocal._internal();
}