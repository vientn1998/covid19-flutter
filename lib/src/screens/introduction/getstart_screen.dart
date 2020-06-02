import 'package:flutter/material.dart';
import 'package:template_flutter/src/app/my_app.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/button.dart';

class GetStartPage extends StatefulWidget {
  @override
  _GetStartPageState createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: Image(image: AssetImage(pathAssets + 'ic_getstart.png'),),
              ),
              SizedBox(
                height: 30,
              ),
              Text('COVID-19', style: kTitleLarge,),
              SizedBox(
                height: 20,
              ),
              Text('Protect yourself and others around you by knowing the facts and taking appropriate', style: kTitle, textAlign: TextAlign.center,),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 52,
                margin: EdgeInsets.only(bottom: 8),
                width: double.infinity,
                child: ButtonCustom(title: 'GET START',textSize: 15, background: textColor, onPressed: () {
                  SharePreferences().saveBool(SharePreferenceKey.isIntroduce, true);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                      fullscreenDialog: true
                  ));
                },),
              )
            ],
          ),
        ),
      ),
    );
  }
}
