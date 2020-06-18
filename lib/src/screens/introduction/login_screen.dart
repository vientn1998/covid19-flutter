import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/screens/introduction/create_account_screen.dart';
import 'package:template_flutter/src/screens/main_screen.dart';
import 'package:template_flutter/src/screens/survey/suvery_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:template_flutter/src/utils/define.dart';
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
  bool isKeyboardAppear = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  String phoneNo, verificationId, smsCode, valuePhoneNumber;
  bool codeSent = false;
  TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: valuePhoneNumber);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          print('aaaa $visible');
          isKeyboardAppear = visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
        gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
        child: Scaffold(
          body: Center(
            child: MultiBlocListener(
              listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is UnAuthenticated ||
                    state is UnInitialized ||
                    state is AuthenticateError) {
                    print('init');
                  } else if (state is Authenticated) {
                    BlocProvider.of<UserBloc>(context).add(CheckUserExists(uuid: state.userObj.id));
                  }
                }),
                BlocListener<UserBloc, UserState>(
                  listener: (buildContext, state) async {
                    if (state is UserLoading) {
                      print('UserLoading');
                      LoadingHud(context).show();
                    } else if (state is UserCheckExistsSuccess) {
                      print('UserCheckExistsSuccess ${state.isExist}');
                      LoadingHud(context).dismiss();
                      if (state.isExist) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(),
                            ));
                      } else {
                        if (BlocProvider.of<AuthBloc>(context).state is Authenticated){
                          final user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).userObj;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseRolePage(userObj: user,),
                              ));
                        }
                      }
                    } else if (state is UserCheckExistsError) {
                      print('UserCheckExistsError');
//                      LoadingDialog(context).loadingHud.dismiss();
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(),
                                                    fullscreenDialog:
                                                    true));
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
                      !isKeyboardAppear
                          ? Column(
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
//                                      BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorFacebook,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      height: 50,
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
                                      //sign google
                                      //_signInWithGoogle().whenComplete(() => print('success login'));
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
                                      height: 50,
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
                      )
                          : Column(
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
                                    if (codeSent) {
                                      signInWithOTP(valuePhoneNumber,verificationId);
                                    } else {
                                      verifyPhone('+84$valuePhoneNumber');
                                    }

                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  Future<void> verifyPhone(phoneNo) async {
    print('phone enter: $phoneNo');
    setState(() {
      valuePhoneNumber = '';
    });
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        print('code : true');
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
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
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('login fb cancelled by user');
          break;
        case FacebookLoginStatus.error:
          print('login fb error');
          break;
      }
    }).catchError((e) {
      print(e.toString());
    });
  }
}
