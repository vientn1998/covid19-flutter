import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_flutter/src/app/simple_bloc_delegate.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/auth_state.dart';
import 'package:template_flutter/src/blocs/chat/bloc.dart';
import 'package:template_flutter/src/blocs/common/bloc.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/blocs/death/bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/blocs/major/bloc.dart';
import 'package:template_flutter/src/blocs/rate/rate_bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/repositories/chat_repository.dart';
import 'package:template_flutter/src/repositories/covid19/covid_api_client.dart';
import 'package:template_flutter/src/repositories/covid19/covid_repository.dart';
import 'package:template_flutter/src/repositories/major_repository.dart';
import 'package:template_flutter/src/repositories/rate_repository.dart';
import 'package:template_flutter/src/repositories/schedule_repository.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import 'package:template_flutter/src/screens/introduction/splash_screen.dart';
import 'package:template_flutter/src/services/notification_service.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:http/http.dart' as http;
import 'src/app/my_app.dart';
import 'src/blocs/schedule/bloc.dart';
import 'src/models/notification_model.dart';
import 'src/screens/introduction/login_screen.dart';
import 'src/screens/introduction/introduction_screen.dart';
import 'src/services/CallsAndMessagesService.dart';

// Streams are created so that app can respond to notification-related events since the
// plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(CallsAndMessagesService(),
      signalsReady: true);
}
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  var notificationPushLocal = NotificationPushLocal();
  ReceivedNotification receivedNotification = ReceivedNotification();
  receivedNotification.title = message["data"]["title"];
  receivedNotification.body = message["data"]["body"];
  notificationPushLocal.showNotificationWhenReceiverPush(receivedNotification);
}

void setupPushFirebase() {
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
    onBackgroundMessage: myBackgroundMessageHandler,
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print("Push Messaging token: $token");
  });
}


main() async {
  //needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  var notificationPushLocal = NotificationPushLocal();
  notificationAppLaunchDetails = await notificationPushLocal
      .flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await notificationPushLocal.flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
  notificationPushLocal.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  setupPushFirebase();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final Covid19Repository covid19repository =
      Covid19Repository(covid19apiClient: Covid19ApiClient());
  final majorRepository = MajorRepository();
  final chatRepository = ChatRepository();
  final userRepository = UserRepository();
  final scheduleRepository = ScheduleRepository();
  final rateRepository = RateRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<Covid19Bloc>(
        create: (context) => Covid19Bloc(covid19repository: covid19repository),
      ),
      BlocProvider<CommonBloc>(
        create: (context) => CommonBloc(),
      ),
      BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(covid19dao: Covid19Dao()),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(userRepository: userRepository),
      ),
      BlocProvider<DeathBloc>(
        create: (context) => DeathBloc(covid19repository: covid19repository),
      ),
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(userRepository: userRepository),
      ),
      BlocProvider<DoctorBloc>(
        create: (context) => DoctorBloc(userRepository: userRepository),
      ),
      BlocProvider<ScheduleBloc>(
        create: (context) => ScheduleBloc(scheduleRepository),
      ),
      BlocProvider<MajorBloc>(
        create: (context) => MajorBloc(majorRepository),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(chatRepository),
      ),
      BlocProvider<RateBloc>(
        create: (context) => RateBloc(rateRepository),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        backgroundColor: Colors.red,
      ),
      home: SplashPage(
        userRepository: userRepository,
      ),
    ),
  ));
}
/*
* 1. createState
* 2. initState
* 3. addPostFrameCallBack: this one need to be called inside your initState()
* 4. didChangeDependencies(). this method is called immediately after initState().
* 5. build(). We can say for sure this method is the most "important" one and called right after
* didChangeDependencies().
* 6. didUpdateWidget().
* 7. deActive()
* 8. dispose().
* */









