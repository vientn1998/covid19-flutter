import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserObj userObj = UserObj();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Logout'),
        onPressed: () async {
          BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());
          SharePreferences().saveBool(SharePreferenceKey.isLogged, false);
          await FacebookLogin().logOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen(),
//                                  fullscreenDialog: true
          ));
        },
      ),
    );
  }

  getUser() async {
    userObj = (await SharePreferences().getObject(SharePreferenceKey.user)) as UserObj;
    print(userObj.toString());
  }
}
