import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/introduction/login_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/styles.dart';

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

  getUser() async {
    userObj = (await SharePreferences().getObject(SharePreferenceKey.user)) as UserObj;
    print(userObj.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0,
//      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(height: heightSpaceLarge,),
              SizedBox(height: heightSpaceNormal,),
              _buildHeader(),
              SizedBox(height: heightSpaceLarge,),
              SizedBox(height: heightSpaceSmall,),
              _buildSection(_buildDataFirstSection()),
              SizedBox(height: heightSpaceNormal,),
              _buildSection(_buildDataSecondSection()),
              SizedBox(height: heightSpaceNormal,),
              _buildSection(_buildDataLogoutSection()),

            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    final heightAvatar = 80.0;
    return Container(
      margin: EdgeInsets.only(left: paddingDefault, right: paddingDefault),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Tran', style: kTitleWelcome,),
              SizedBox(height: 10,),
              Text('Edit profile', style: TextStyle(fontSize: 14, color: textColor, decoration: TextDecoration.underline),),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(heightAvatar/2),
            ),
            height: heightAvatar,
            width: heightAvatar,
            child: Material(
              child: CircleAvatar(
                child: Icon(Icons.print),
                backgroundColor: Colors.white,
              ),
              elevation: 2,
              borderRadius: BorderRadius.circular(heightAvatar/2),
            ),
          )
        ],
      ),
    );
  }

  _buildSection(Widget widget) {
    return Container(
      margin: EdgeInsets.only(left: paddingDefault, right: paddingDefault),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: widget,
    );
  }

  _buildDataFirstSection() {
    return Column(
      children: <Widget>[
        _buildRowItem("Medical examination","2"),
        _buildLine(),
        _buildRowItem("Notification","4"),
      ],
    );
  }

  _buildDataSecondSection() {
    return Column(
      children: <Widget>[
        _buildRowItem("Visited address",""),
        _buildLine(),
        _buildRowItem("Change language","0"),
        _buildLine(),
        _buildRowItem("Support","0"),
      ],
    );
  }
  _buildDataLogoutSection() {
    return Column(
      children: <Widget>[
        _buildRowItem("Logout","0"),
      ],
    );
  }

  _buildLine() {
    return Container(height: 1, width: double.infinity, color: Colors.grey.withOpacity(0.2),
      margin: EdgeInsets.only(left: heightSpaceSmall, right: heightSpaceSmall),);
  }

  _buildRowItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(heightSpaceSmall),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.favorite, color: Colors.red,),
          SizedBox(width: 10,),
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black87),),
          Spacer(),
          Text(value == '0' ? '' : value,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),),
          value == '0' ? SizedBox() : Icon(Icons.navigate_next, color: colorIcon,),
        ],
      ),
    );
  }
}

//RaisedButton(
//child: Text('Logout'),
//onPressed: () async {
//BlocProvider.of<AuthBloc>(context).add(AuthLogoutGoogle());
//SharePreferences().saveBool(SharePreferenceKey.isLogged, false);
//await FacebookLogin().logOut();
//Navigator.pushReplacement(context, MaterialPageRoute(
//builder: (context) => LoginScreen(),
////                                  fullscreenDialog: true
//));
//},
//)