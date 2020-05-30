import 'package:flutter/material.dart';
import 'package:template_flutter/src/screens/introduction/getstart_screen.dart';

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
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => GetStartScreen(),
//                                  fullscreenDialog: true
          ));
        },
      ),
    );
  }
}
