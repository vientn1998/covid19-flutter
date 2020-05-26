import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/screens/introduction/introduction_screen.dart';
import 'package:template_flutter/src/screens/main_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

import 'getstart_screen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Future<void> checkLogin() async {
    final isIntroduce = await SharePreferences().getBool(SharePreferenceKey.isIntroduce);
    print(isIntroduce);
    Timer(Duration(seconds: 3), () async {
      if (isIntroduce == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => OnBoardingPage(),
        ));
      } else {
        final isSurvey = await SharePreferences().getBool(SharePreferenceKey.isApproveSuvery);
        if (isSurvey == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => GetStartScreen(),
          ));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MainPage(),
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
        color: colorFacebook,
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
