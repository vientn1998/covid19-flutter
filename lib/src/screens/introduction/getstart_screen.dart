import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/screens/survey/suvery_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:template_flutter/src/utils/styles.dart';

class GetStartScreen extends StatefulWidget {
  @override
  _GetStartScreenState createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen> {
  bool isKeyboardAppear = false;
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      setState(() {
        isKeyboardAppear = visible;
      });
    },);
  }
  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
    child: Scaffold(
      body: Center(
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
                          image: AssetImage('assets/images/ic_logo.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 60,
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
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => MyApp(),
                                          fullscreenDialog: true
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: backgroundTextInput,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                      ),
                                      height: 46,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/ic_vn.png'),
                                            ),
                                            SizedBox(width: 5,),
                                            Text('+84', style: TextStyle(
                                                fontSize: 16
                                            ),)
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
                                        BorderRadius.all(Radius.circular(4)),
                                      ),
                                      child: TextField(
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                        inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
                                        maxLines: 1,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                !isKeyboardAppear ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Or continue with a social account', style: kTitle,),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorFacebook,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                              ),
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/ic_facebook.png'),
                                    ),
                                    SizedBox(width: 15,),
                                    Text('Facebook', style: TextStyle(fontSize: 17, color: Colors.white),)
                                  ],
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
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorGoogle,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                              ),
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/ic_google.png'),
                                    ),
                                    SizedBox(width: 15,),
                                    Text('Google', style: TextStyle(fontSize: 17, color: Colors.white),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ) :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            child: Text('continue', style: kTitle,),
                            onPressed: () async {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => SurveyPage(),
//                                  fullscreenDialog: true
                              ));
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
  );
}
