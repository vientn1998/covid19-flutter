import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/widgets/button.dart';

import '../main_screen.dart';
import 'choose_role_screen.dart';

class EnterOTPPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final bool isPhoneExists;
  EnterOTPPage({@required this.phoneNumber, @required this.verificationId, this.isPhoneExists = false});

  @override
  _EnterOTPPageState createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  FocusNode _focus = new FocusNode();

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 119;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (!mounted) return;
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    errorController = StreamController<ErrorAnimationType>();
    hasError = true;
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
//    textEditingController.dispose();
//    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Verification',
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is UserLoading) {
            LoadingHud(context).dismiss();
          } else if (state is GetDetailsError) {
            LoadingHud(context).dismiss();
          } else if (state is GetDetailsSuccessfully) {
            LoadingHud(context).dismiss();
            final data = jsonEncode(state.userObj);
            SharePreferences().saveString(SharePreferenceKey.user, data);
            SharePreferences().saveString(SharePreferenceKey.uuid, state.userObj.id);

//            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                )
            );
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: heightSpaceLarge),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ],
                      style: TextStyle(color: textColor, fontSize: 16)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                child: PinCodeTextField(
                  length: 6,
                  focusNode: _focus,
                  obsecureText: false,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: Colors.blue,
                      inactiveColor: textColor),
                  animationDuration: Duration(milliseconds: 100),
                  autoFocus: true,
                  textInputType: TextInputType.numberWithOptions(decimal: false),
                  controller: textEditingController,
                  textStyle: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                  errorAnimationController: errorController,
                  //pass it here
                  onCompleted: (v) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      hasError = true;
                      currentText = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              currentSeconds == timerMaxSeconds ? RichText(text: TextSpan(
                  text: "Didn\'t receive the code?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
                  children: [
                    TextSpan(
                      text: " Resend".toUpperCase(),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        setState(() {
                          currentSeconds = 0;
                        });
                        startTimeout();
                        final authCredential =  PhoneAuthProvider.getCredential(verificationId: widget.verificationId, smsCode: '000000');
                        final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(authCredential).catchError((error) {
                          print('error $error');
                          return;
                        });
                        if (authResult != null && authResult.user != null && authResult.user.uid != null && authResult.user.uid.length > 0) {
                          UserObj userObj = UserObj(id: authResult.user.uid, phone: widget.phoneNumber);
                          print('user sms: $userObj');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseRolePage(userObj: userObj,),
                              ));
                        } else {
                          showError();
                        }
                      },
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.red),
                    )
                  ]
              )) : RichText(text: TextSpan(
                  text: "Resend code in ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: textColor),
                  children: [
                    TextSpan(text: timerText, style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w800))
                  ]
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(paddingNavi),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Verify',
                    isEnable: !hasError,
                    background: colorActive,
                    onPressed: () {
                      LoadingHud(context).show();
                      FocusScope.of(context).unfocus();
                      signInWithOTP(currentText);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithOTP(smsCode) async {
    print('code $smsCode');
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId, smsCode: smsCode);
    final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(authCredential).catchError((error) {
      print('error $error');
      return;
    });

    if (authResult != null) {
      final user = authResult.user;
      if (user.uid != null && user.uid.isNotEmpty) {
        UserObj userObj = UserObj(id: user.uid, phone: widget.phoneNumber);
        print('user sms: $userObj');
        if (widget.isPhoneExists) {
          BlocProvider.of<UserBloc>(context).add(GetDetailsUserByPhone(widget.phoneNumber));
        } else {
          LoadingHud(context).dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseRolePage(userObj: userObj,),
              ));
        }
      } else {
        showError();
      }
    } else {
      showError();
    }
  }

  showError(){
    LoadingHud(context).dismiss();
    toast('You have entered an invalid code. Please try again.', gravity: ToastGravity.BOTTOM);
    textEditingController.clear();
    FocusScope.of(context).requestFocus(_focus);
  }

}
