import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/doctor/doctor_screen.dart';
import 'package:template_flutter/src/screens/map/map_screen.dart';
import 'package:template_flutter/src/screens/profile/profile_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

import 'home/home_screen.dart';

class MainPage extends StatefulWidget {

  final UserObj userObj;

  MainPage({this.userObj});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  UserObj userObj;
  @override
  void initState() {
    //getUser();
    userObj = widget.userObj ?? UserObj();
    super.initState();
  }

  getUser() async {
    final dataMap = await SharePreferences().getObject(SharePreferenceKey.user);
    if (dataMap != null) {
      final data = UserObj.fromJson(dataMap);
      if (data != null) {
        setState(() {
          userObj = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is GetDetailsError) {
            print('Get user details: error');
          } else if (state is GetDetailsSuccessfully) {
            final user = jsonEncode(state.userObj);
            SharePreferences().saveString(SharePreferenceKey.user, user);
          }
        },
        child: SafeArea(
          top: false,
          child: userObj.isDoctor ? IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              HomePage(),
              MapPage(),
              ProfilePage(),
            ],
          ) : IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              HomePage(),
              DoctorPage(),
              ProfilePage(),
            ],
          )
          ,
        ),
      ),
      bottomNavigationBar: userObj.isDoctor ? BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.purpleAccent,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.map),
              title: Text('Map'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text('Profile'),
              activeColor: Colors.purpleAccent
          ),
        ],
      ) : BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.purpleAccent,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.enhanced_encryption),
              title: Text('Doctor'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text('Profile'),
              activeColor: Colors.purpleAccent
          ),
        ],
      ),
    );
  }

  getUserDetails() async{
    final uuid = await SharePreferences().getString(SharePreferenceKey.uuid) ?? '';
    BlocProvider.of<UserBloc>(context).add(GetDetailsUser(uuid));
  }
}
