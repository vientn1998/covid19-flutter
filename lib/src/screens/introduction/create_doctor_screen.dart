import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/image_picker.dart';
import 'package:template_flutter/src/utils/size_config.dart';
import 'package:template_flutter/src/widgets/button.dart';
import 'package:template_flutter/src/widgets/text_field.dart';
import 'package:template_flutter/src/widgets/text_field_dropdown.dart';

import '../main_screen.dart';

class CreateDoctorPage extends StatefulWidget {

  final UserObj userObj;

  CreateDoctorPage({Key key, this.userObj});

  @override
  _CreateDoctorState createState() => _CreateDoctorState();
}

class _CreateDoctorState extends State<CreateDoctorPage> {
  String valueGender, valueBirthday, valueName, valueEmail,valuePhone;
  DateTime dateTimeBirthday;
  File _fileAvatar;
  bool isHasAvatar = false;
  @override
  void initState() {
    super.initState();
    valueGender = 'Gender';
    valueBirthday = 'Birthday';
    valueName = widget.userObj.name;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _widthHeightAvatar = SizeConfig.screenWidth / 4;
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserCreateLoading) {
                LoadingHud(context).show();
                print('Create Loading');
              } else if (state is UserCreateSuccess) {
                LoadingHud(context).dismiss();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => MainPage(),
                ));
              } else if (state is UserCreateError) {
                LoadingHud(context).dismiss();
                print('Create error');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 23,
                    ),
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(_widthHeightAvatar / 2),
                        ),
                        height: _widthHeightAvatar,
                        width: _widthHeightAvatar,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      (_widthHeightAvatar) / 2)),
                              height: _widthHeightAvatar,
                              width: _widthHeightAvatar,
                              child: ClipOval(
                                child: loadAvatar(_fileAvatar,widget.userObj.avatar),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0, 0),
                              child: isHasAvatar ? null :Icon(Icons.perm_identity, size: 30, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(_widthHeightAvatar / 2),
                      elevation: 0,
                      color: backgroundSearch,
                    ),
                    FlatButton(
                      child: (widget.userObj.avatar != null && widget.userObj.avatar.isNotEmpty) || _fileAvatar != null ? Text('Edit avatar') : Text('Add avatar'),
                      onPressed: () async {
                        final data = await showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                isDefaultAction: true,
                                child: const Text('Cancel', style: TextStyle(color: Colors.red),),

                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                    child: const Text('Take a photo'), onPressed: () async {
                                  Navigator.pop(context);
                                  final file = await ImagePickUtils().getImageCamera();
                                  setState(() {
                                    _fileAvatar = file;
                                  });
                                }),
                                CupertinoActionSheetAction(
                                    child: const Text('Choose from gallery'), onPressed: () async {
                                  Navigator.pop(context);
                                  final file = await ImagePickUtils().getImageGallery();
                                  setState(() {
                                    _fileAvatar = file;
                                  });
                                }),
                              ]),
                        );

                        print(data);
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                        hint: 'Full name',
                        value: widget.userObj.name,
                        iconData: Icons.perm_identity,
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            valueName = value;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      value: widget.userObj.email,
                      iconData: Icons.email,
                      textInputType: TextInputType.text,
                      isEnable: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        hint: 'Phone',
                        iconData: Icons.phone,
                        textInputType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            valuePhone = value;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldDropDown(
                      value: valueGender,
                      iconData: Icons.keyboard_arrow_down,
                      onChanged: () async {
                        final data = await showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                isDefaultAction: true,
                                child: const Text('Cancel', style: TextStyle(color: Colors.red),),

                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                    child: const Text('Male'), onPressed: () {
                                  Navigator.pop(context, 'Male');
                                }),
                                CupertinoActionSheetAction(
                                    child: const Text('Female'), onPressed: () {
                                  Navigator.pop(context, 'Female');
                                }),
                              ]),
                        );
                        setState(() {
                          if (data != null) {
                            valueGender = data;
                          }
                        });
                        print(data);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldDropDown(
                      value: valueBirthday,
                      iconData: Icons.calendar_today,
                      onChanged: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1975, 1, 1),
                            maxTime: DateTime.now(), onConfirm: (date) {
                              print(DateTimeUtils().formatDateString(date));
                              setState(() {
                                dateTimeBirthday = date;
                                valueBirthday = DateTimeUtils().formatDateString(date);
                              });
                            }, currentTime: dateTimeBirthday ?? DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: ButtonCustom(
                          title: 'Create',
                          background: colorActive,
                          onPressed: () {
                            final user = UserObj();
                            user.id = widget.userObj.id;
                            user.name = valueName;
                            user.email = widget.userObj.email;
                            user.phone = valuePhone;
                            user.gender = valueGender == "Gender" ? "" : valueGender;
                            user.birthday = valueBirthday == "Birthday" ? 0 : dateTimeBirthday.millisecondsSinceEpoch;
                            print('data submit');
                            print(user.toString());
                            if (_fileAvatar == null) {
                              if (widget.userObj.avatar != null && widget.userObj.avatar.isNotEmpty) {
                                user.avatar = widget.userObj.avatar;
                                BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user));
                              } else {
                                BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user));
                              }
                            } else {
                              BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user, file: _fileAvatar));
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadAvatar(File file, String url) {
    if (file != null) {
      setState(() {
        isHasAvatar = true;
      });
      return Image.file(_fileAvatar, fit: BoxFit.cover,);
    } else if (url != null && url.isNotEmpty) {
      isHasAvatar = true;
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => null,
      );
    } else {
      return null;
    }
  }
}