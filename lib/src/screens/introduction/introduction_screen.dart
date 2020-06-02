import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';

import 'getstart_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => GetStartPage()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: ClipRRect(
        child: Image(image: AssetImage('assets/images/$assetName.png'), width: 350,),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: kTitleIntro,
      bodyTextStyle: kTitle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Quarantine",
          body:
          "Each individual should protect himself.",
          image: _buildImage('intro_1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Explore the map",
          body:
          "Warning for hazardous areas to keep away.",
          image: _buildImage('intro_4'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Call a doctor to visit you",
          body:
          "Easily find a doctor and schedule a cure.",
          image: _buildImage('intro_2'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
