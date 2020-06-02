import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
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
          BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());
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
