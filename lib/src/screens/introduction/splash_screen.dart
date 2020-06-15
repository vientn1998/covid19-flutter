import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import 'package:template_flutter/src/screens/introduction/introduction_screen.dart';
import 'package:template_flutter/src/screens/main_screen.dart';
import 'package:template_flutter/src/screens/survey/suvery_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/hex_color.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

import 'login_screen.dart';

class SplashPage extends StatefulWidget {

  final UserRepository userRepository;


  SplashPage({this.userRepository}) : assert(userRepository != null);


  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Future<void> checkLogin() async {
    final isIntroduce = await SharePreferences().getBool(SharePreferenceKey.isIntroduce);
    Timer(Duration(seconds: 1), () async {
      if (isIntroduce == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => OnBoardingPage(),
        ));
      } else {
        final isLogin = await widget.userRepository.isSignedIn();
        print('isLogin $isLogin');
        if (isLogin) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MainPage(),
          ));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(LoadingSearchFile(context: context));
    BlocProvider.of<SearchBloc>(context).add(LoadingSearch());
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#2979FF"),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment(0, 0),
              child:
              Image(image: AssetImage('assets/images/ic_logo.png'),
                height: 100,
                width: 100,),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: Container(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
