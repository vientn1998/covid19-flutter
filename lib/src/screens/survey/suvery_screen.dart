import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/button.dart';

import '../main_screen.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  static int currentIndex = 0;
  PageController _pageController = PageController(initialPage: currentIndex, keepPage: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('COVID-19 Test', style: kTitleIntro,),
                          SizedBox(height: heightSpaceNormal,),
                          Text('Have you had a test for\nCOVID-19?', style: kTitleSurvey,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Yes',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 1;
                              });
                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonOutlineCustom(title: 'No',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
//                              _pageController.jumpToPage(1);
                              _pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 1;
                              });
                            },),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('Do you have a fever?', style: kTitleIntro,),
                          SizedBox(height: heightSpaceNormal,),
                          Text('Are you currently experiencing a high temperature?', style: kTitleSurvey,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Yes',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 2;
                              });
                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonOutlineCustom(title: 'No',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 2;
                              });
                            },),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('Do you have a persistent cough?', style: kTitleIntro,),
                          SizedBox(height: heightSpaceNormal,),
                          Text('Coughing a lot for more than hour or 3 episodes in the past 24hrs?', style: kTitleSurvey,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Yes',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(3, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 3;
                              });
                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonOutlineCustom(title: 'No',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(3, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 3;
                              });
                            },),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('COVID-19 Status?', style: kTitleIntro,),
                          SizedBox(height: heightSpaceNormal,),
                          Text('Did you test positive for COVID-19?', style: kTitleSurvey,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Yes',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(4, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 4;
                              });
                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonOutlineCustom(title: 'No',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              _pageController.animateToPage(4, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                currentIndex = 4;
                              });
                            },),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('How do you feel right now?', style: kTitleIntro,),
                          SizedBox(height: heightSpaceNormal,),
                          Text('Try to let us know how you\'re felling right now?', style: kTitleSurvey,),
                          SizedBox(height: heightSpaceLarge,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Great',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => ThanksForSurvey(),
//                                  fullscreenDialog: true
                              ));
                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Normal',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {

                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonCustom(title: 'Not Good',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {

                            },),
                          ),
                          SizedBox(height: heightSpaceNormal,),
                          Container(
                            height: heightButton,
                            margin: EdgeInsets.only(bottom: 0),
                            width: double.infinity,
                            child: ButtonOutlineCustom(title: 'Awful',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {

                            },),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              StepProgressIndicator(
                totalSteps: 5,
                currentStep: currentIndex + 1,
                selectedColor: colorButtonSurvey,
                unselectedColor: backgroundTextInput,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ThanksForSurvey extends StatefulWidget {
  @override
  _ThanksForSurveyState createState() => _ThanksForSurveyState();
}

class _ThanksForSurveyState extends State<ThanksForSurvey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSurvey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/ic_logo.png'),
                  ),
                ],
              ),
              SizedBox(height: heightSpaceLarge,),
              SizedBox(height: heightSpaceLarge,),
              Text('Thanks you for your help and vital contribution the study of COVID-19', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white
              ),),
              SizedBox(height: heightSpaceNormal,),
              Text('We would appreciate it if you could check back in tomorrow. Knowing people healthy is extremely helpful.', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white
              ),),
              SizedBox(height: heightSpaceNormal,),
              SizedBox(height: heightSpaceLarge,),
              Container(
                height: heightButton,
                margin: EdgeInsets.only(bottom: 0),
                width: double.infinity,
                child: ButtonCustom(title: 'Share This App',textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {

                },),
              ),
              SizedBox(height: heightSpaceNormal,),
              Container(
                height: heightButton,
                margin: EdgeInsets.only(bottom: 0),
                width: double.infinity,
                child: ButtonOutlineCustom(title: 'Go Back Home',color: Colors.white,textSize: 16,borderRadius: borderRadiusButtonOutline, background: colorButtonSurvey, onPressed: () {
                  SharePreferences().saveBool(SharePreferenceKey.isApproveSuvery, true);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ));
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

