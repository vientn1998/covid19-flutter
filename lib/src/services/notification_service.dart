import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:template_flutter/src/models/notification_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
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

  Future<void> showNotificationAddSchedule(ScheduleModel scheduleModel) async {
    print('showNotificationAddSchedule');
    print('${scheduleModel.timeBook} - ${DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime)}');
    var bigTextStyleInformation = BigTextStyleInformation(
        '${scheduleModel.sender.name} đã yêu cầu khám bệnh vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.',
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id', 'name', 'description',
        styleInformation: bigTextStyleInformation,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (TargetPlatform.iOS != null) {
      await flutterLocalNotificationsPlugin.show(
          scheduleModel.dateTime ~/ 1000,
          'Bạn có 1 cuộc hẹn mới',
          '${scheduleModel.sender.name} đã yêu cầu khám bệnh vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.', platformChannelSpecifics,
          payload: 'item x');
    } else {
      await flutterLocalNotificationsPlugin.show(
          scheduleModel.dateTime ~/ 1000,
          'Bạn có 1 cuộc hẹn mới',
          null, platformChannelSpecifics,
          payload: 'item x');
    }

  }

  Future<void> showNotificationChangeStatusOfUserSchedule(ScheduleModel scheduleModel) async {
    print('showNotificationChangeStatusOfUserSchedule');
    var message = "";
    if (scheduleModel.status == StatusSchedule.Approved.toCastEnumIntoString()) {
      message = "Cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))} đã được chấp nhận.";
    } else if (scheduleModel.status == StatusSchedule.Canceled.toCastEnumIntoString()) {
      message = "Cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))} đã bị huỷ.";
    }
    var bigTextStyleInformation = BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id', 'name', 'description',
        styleInformation: bigTextStyleInformation,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (TargetPlatform.iOS != null) {
      await flutterLocalNotificationsPlugin.show(
          scheduleModel.dateTime ~/ 1000,
          'Bạn có 1 thông báo mới',
          message, platformChannelSpecifics,
          payload: 'item x');
    } else {
      await flutterLocalNotificationsPlugin.show(
          scheduleModel.dateTime ~/ 1000,
          'Bạn có 1 cuộc hẹn mới',
          null, platformChannelSpecifics,
          payload: 'item x');
    }

  }

  Future<void> showNotificationWhenReceiverPush(ReceivedNotification notification) async {
    print('showNotificationWhenReceiverPush: ' + notification.toString() );
    var message = notification.body;
    var bigTextStyleInformation = BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id', 'name', 'description',
        styleInformation: bigTextStyleInformation,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (TargetPlatform.iOS != null) {
      await flutterLocalNotificationsPlugin.show(
          1,
          notification.title,
          message, platformChannelSpecifics,
          payload: 'item x');
    } else {
      await flutterLocalNotificationsPlugin.show(
          1,
          notification.title,
          null, platformChannelSpecifics,
          payload: 'item x');
    }

  }

  Future<void> scheduleNotificationUser(ScheduleModel scheduleModel) async {
    var scheduledNotificationDateTime = DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime)
        .add(Duration(minutes: scheduleModel.timeBook * 60 - 15));
    print('${scheduleModel.timeBook * 60} - ${scheduledNotificationDateTime}');
    var bigTextStyleInformation = BigTextStyleInformation(
        'Bạn có cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.',
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id',
        'name',
        'description',
      enableVibration: true,
      styleInformation: bigTextStyleInformation,
      icon: '@mipmap/ic_launcher',
    );
    final mess = 'Bạn có cuộc hẹn với bác sĩ ${scheduleModel.receiver.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.';
    print(mess);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (TargetPlatform.iOS != null) {
      await flutterLocalNotificationsPlugin.schedule(
          scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook,
          'Nhắc nhở lịch khám bệnh',
          mess,
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'abc'
      );
    } else {
      await flutterLocalNotificationsPlugin.schedule(
          scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook,
          'Nhắc nhở lịch khám bệnh',
          null,
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'abc'
      );
    }

  }

  Future<void> scheduleNotificationDoctor(ScheduleModel scheduleModel) async {
    var scheduledNotificationDateTime = DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime)
        .add(Duration(minutes: scheduleModel.timeBook * 60 - 15));
    print('${scheduleModel.timeBook * 60} - ${scheduledNotificationDateTime}');
    final mess = 'Bạn có cuộc hẹn với bệnh nhân ${scheduleModel.sender.name} vào lúc ${scheduleModel.timeBook.getTypeTimeSchedule()} ngày ${DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(scheduleModel.dateTime))}.';
    var bigTextStyleInformation = BigTextStyleInformation(
        mess,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'id',
      'name',
      'description',
      enableVibration: true,
      styleInformation: bigTextStyleInformation,
      icon: '@mipmap/ic_launcher',
    );

    print(mess);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print('id notification: ${scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook}');
    if (TargetPlatform.iOS != null) {
      await flutterLocalNotificationsPlugin.schedule(
          scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook,
          'Nhắc nhở khám bệnh',
          mess,
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'abc'
      );
    } else {
      await flutterLocalNotificationsPlugin.schedule(
          scheduleModel.dateTime ~/ 1000 + scheduleModel.timeBook,
          'Nhắc nhở khám bệnh',
          null,
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          payload: 'abc'
      );
    }
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