import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/size_config.dart';
import 'package:template_flutter/src/widgets/button.dart';
import 'package:template_flutter/src/widgets/text_field.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Material(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((SizeConfig.screenWidth / 4) / 2)
                      ),
                      height: SizeConfig.screenWidth / 4,
                      width: SizeConfig.screenWidth / 4,
                      child: CircleAvatar(
                        child: Icon(Icons.perm_identity, size: 35,),
                        backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                  elevation: 3,
                  borderRadius: BorderRadius.circular((SizeConfig.screenWidth / 4) / 2),
                ),
                SizedBox(height: 50,),
                CustomTextField(hint: 'Full name', iconData: Icons.perm_identity
                  , textInputType: TextInputType.text, textCapitalization: TextCapitalization.words,),
                SizedBox(height: 20,),
                CustomTextField(value: 'ngoxvien2020@gmail.com', iconData: Icons.email
                  , textInputType: TextInputType.text, isEnable: false,),
                SizedBox(height: 20,),
                CustomTextField(hint: 'Phone', iconData: Icons.phone
                  , textInputType: TextInputType.phone,),
                SizedBox(height: 30,),

                Container(
                  height: 46,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ButtonCustom(title: 'Create', background: colorActive, onPressed: () {

                    },),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
