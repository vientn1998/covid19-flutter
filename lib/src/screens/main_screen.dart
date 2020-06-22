import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/screens/doctor/doctor_screen.dart';
import 'package:template_flutter/src/screens/map/map_screen.dart';
import 'package:template_flutter/src/screens/profile/profile_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

import 'home/home_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    getUserDetails();
    super.initState();
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
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              HomePage(),
              MapPage(),
              DoctorPage(),
              ProfilePage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
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
              icon: Icon(Icons.enhanced_encryption),
              title: Text('Doctor'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text('User'),
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
