import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/introduction/create_doctor_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/widgets/button.dart';

import 'create_account_screen.dart';

enum RoleApp {
  doctor,
  user
}

class ChooseRolePage extends StatefulWidget {
  final UserObj userObj;
  final String phoneNumber;
  ChooseRolePage({Key key, this.userObj, this.phoneNumber}): super(key: key);
  @override
  _ChooseRolePageState createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {

  RoleApp _roleApp = RoleApp.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Choose Role', style: kTitleWelcome,),
              SizedBox(height: 50,),
              widgetRadioButton(RoleApp.user, (value) {
                setState(() {
                  _roleApp = value;
                });
              }),
              SizedBox(height: 32,),
              widgetRadioButton(RoleApp.doctor, (value) {
                setState(() {
                  _roleApp = value;
                });
              }),
              SizedBox(height: 50,),
              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Create',
                    background: colorActive,
                    onPressed: () {
                      if (_roleApp == RoleApp.user) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountPage(userObj: widget.userObj,),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateDoctorPage(userObj: widget.userObj,),
                            ));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetRadioButton(RoleApp role, Function(RoleApp) function) {
    bool isDoctor = role == RoleApp.doctor;
    final subTitle = isDoctor
        ? 'Khám bệnh, chữa bệnh, xem lịch...'
        : 'Tìm bác sĩ, tạo lịch hẹn, đánh giá...';
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: Colors.white54
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: colorRecovered,

        ),
        child: RadioListTile(
          value: role,
          groupValue: _roleApp,
          onChanged: function,
          activeColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
          title: new Text(role == RoleApp.user ? 'User' : 'Doctor', style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500
          ),),
          subtitle: new Text(subTitle, style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.normal
          ),),
        ),
      ),
    );
  }
}
