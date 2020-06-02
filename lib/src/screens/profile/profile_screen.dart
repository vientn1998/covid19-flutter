import 'package:flutter/material.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Logout'),
        onPressed: () {
          SharePreferences().saveBool(SharePreferenceKey.isLogin, false);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen(),
//                                  fullscreenDialog: true
          ));
        },
      ),
    );
  }
}
