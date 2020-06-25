import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
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
        final isLogged = await SharePreferences().getBool(SharePreferenceKey.isLogged);
        print('was login:  $isLogged');
        if (isLogged ?? false) {
          final uuid = await SharePreferences().getString(SharePreferenceKey.uuid) ?? '';
          BlocProvider.of<UserBloc>(context).add(GetDetailsUser(uuid));
        } else {
          BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());
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
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is GetDetailsError) {
            print('Get user details: error');
          } else if (state is GetDetailsSuccessfully) {
            final user = jsonEncode(state.userObj);
            await SharePreferences().saveString(SharePreferenceKey.user, user);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => MainPage(userObj: state.userObj,),
            ));
          }
        },
        child: Container(
          color: HexColor("#2979FF"),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment(0, 0),
                child:
                Image(image: AssetImage('assets/images/ic_virus.png'),
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
      )
    );
  }
}
