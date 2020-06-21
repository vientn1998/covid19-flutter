import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/introduction/create_account_screen.dart';
import 'package:template_flutter/src/screens/introduction/enter_code_sms_screen.dart';
import 'package:template_flutter/src/screens/main_screen.dart';
import 'package:template_flutter/src/screens/survey/suvery_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/loading_dialog.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:http/http.dart' as http;

import 'choose_role_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isKeyboardAppear = false, isEnableButtonPhone = false;
  final facebookLogin = FacebookLogin();
  String phoneNo, verificationId, smsCode, valuePhoneNumber;
  bool codeSent = false;
  TextEditingController textEditingController;
  @override
  void initState() {
    valuePhoneNumber = '';
    isEnableButtonPhone = false;
    isKeyboardAppear = false;
    textEditingController = TextEditingController(text: valuePhoneNumber);
    super.initState();
    KeyboardVisibility.onChange.listen((visible) {
      print('isKeyboardAppear : $visible');
      setState(() {
        isKeyboardAppear = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) => KeyboardDismissOnTap(
        child: Scaffold(
          body: Center(
            child: MultiBlocListener(
              listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is UnAuthenticated ||
                    state is UnInitialized ||
                    state is AuthenticateError) {
                  } else if (state is Authenticated) {
                    BlocProvider.of<UserBloc>(context).add(CheckUserExists(uuid: state.userObj.id));
                  } else if (state is SenCodeWasSuccessful) {
                    LoadingHud(context).dismiss();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ));
                  }
                }),
                BlocListener<UserBloc, UserState>(
                  listener: (buildContext, state) async {
                    if (state is UserLoading) {
                      LoadingHud(context).show();
                    } else if (state is UserCheckExistsSuccess) {
                      print('UserCheckExistsSuccess ${state.isExist}');
                      LoadingHud(context).dismiss();
                      final user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).userObj;
                      if (state.isExist) {
                        SharePreferences().saveString(SharePreferenceKey.uuid, user.id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(),
                            ));
                      } else {
                        if (BlocProvider.of<AuthBloc>(context).state is Authenticated){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseRolePage(userObj: user,),
                              ));
                        }
                      }
                    } else if (state is UserCheckPhoneSuccess) {
                      print('Phone exists: ${state.isExist}');
                      if (state.isExist) {
                        LoadingHud(context).dismiss();
                        SharePreferences().saveString(SharePreferenceKey.uuid, state.phoneNumber);
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(),
                            )
                        );
                      } else {
                        verifyPhone(state.phoneNumber);
                      }
                    } else if (state is UserCheckExistsError) {
                      print('UserCheckExistsError');
                      LoadingHud(context).dismiss();
                    }
                  },
                ),
              ],
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 70,
                              ),
                              Image(
                                image:
                                AssetImage('assets/images/ic_logo.png'),
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    'Welcome',
                                    style: kTitleWelcome,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Enter your mobile number to continue',
                                    style: kTitle,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: backgroundTextInput,
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(4)),
                                            ),
                                            height: 46,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Image(
                                                    image: AssetImage(
                                                        'assets/images/ic_vn.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '+84',
                                                    style: TextStyle(
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: backgroundTextInput,
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(4)),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(
                                                    RegExp('[0-9]'))
                                              ],
                                              onChanged: (phone) {
                                                setState(() {
                                                  valuePhoneNumber = phone;
                                                  isEnableButtonPhone = (phone != null && phone.length == 9);
                                                });
                                              },
                                              controller: textEditingController,
                                              maxLines: 1,
                                              keyboardType:
                                              TextInputType.phone,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  hintText: '87654321'),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      isKeyboardAppear ? buildWidgetKeyboardAppear() : buildWidgetKeyboardDismiss()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  buildWidgetKeyboardAppear() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Text(
                  'continue',
                  style: kTitle,
                ),
                onPressed: () async {
                  if (valuePhoneNumber.isEmpty) {
                    toast('Please input phone number');
                    return;
                  }
                  if (valuePhoneNumber.length != 9) {
                    toast('Invalid phone number');
                    return;
                  }
                  LoadingHud(context).show();
                  final phone = '0$valuePhoneNumber';
                  print('phone number: $phone');
                  BlocProvider.of<UserBloc>(context).add(CheckPhoneExists(phone: phone));

                  //BlocProvider.of<AuthBloc>(context).add(AuthPhoneNumberPressed('+84$valuePhoneNumber'));
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  buildWidgetKeyboardDismiss() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Or continue with a social account',
          style: kTitle,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Material(
                elevation: 2,
                borderRadius:
                BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {
                    //facebook
                    _signInWithFacebook();

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorFacebook,
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(4)),
                    ),
                    height: heightButton,
                    child: Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                                'assets/images/ic_facebook.png'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Facebook',
                            style: TextStyle(
                                fontSize: 17,
                                color:
                                Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Material(
                elevation: 2,
                borderRadius:
                BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {
                    //google
                    BlocProvider.of<AuthBloc>(
                        context)
                        .add(AuthGooglePressed());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorGoogle,
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(4)),
                    ),
                    height: heightButton,
                    child: Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                                'assets/images/ic_google.png'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Google',
                            style: TextStyle(
                                fontSize: 17,
                                color:
                                Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final phone = '+84${valuePhoneNumber.substring(0)}';
    print('phone verify $phone');
    setState(() {
      valuePhoneNumber = '';
    });
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
      toast('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        LoadingHud(context).dismiss();
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => EnterOTPPage(phoneNumber: phoneNo, verificationId: this.verificationId,),
        ));
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<void> _signInWithFacebook() async {
    await facebookLogin.logIn(['email', 'public_profile']).then((result) async {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print('login fb success \n ${result.accessToken.token}');
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
          print(graphResponse.body);
          final profile = json.decode(graphResponse.body);
          final user = UserObj();
          user.id = profile["id"];
          user.name = profile["name"];
          user.email = profile["email"];
          user.accessTokenFb = result.accessToken.token;
          user.isAuthFb = true;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseRolePage(userObj: user,),
              ));
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('login fb cancelled by user');
          break;
        case FacebookLoginStatus.error:
          DialogCus(context).show(message: 'Login fb error');
          break;
      }
    }).catchError((e) {
      print(e.toString());
    });
  }
}
