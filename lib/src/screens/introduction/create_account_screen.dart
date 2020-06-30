import 'dart:convert';
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
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/image_picker.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/size_config.dart';
import 'package:template_flutter/src/utils/validator.dart';
import 'package:template_flutter/src/widgets/button.dart';
import 'package:template_flutter/src/widgets/text_field.dart';
import 'package:template_flutter/src/widgets/text_field_dropdown.dart';

import '../main_screen.dart';

class CreateAccountPage extends StatefulWidget {

  final UserObj userObj;
  CreateAccountPage({Key key, @required this.userObj}): assert(userObj != null);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String valueGender, valueBirthday, valueName, valueEmail,valuePhone;
  DateTime dateTimeBirthday;
  File _fileAvatar;
  bool isHasAvatar = false;
  bool isAuthPhone;
  @override
  void initState() {
    super.initState();
    valueGender = 'Choose gender';
    valueBirthday = 'Choose birthday';
    valueEmail = widget.userObj.email == null ? '' : widget.userObj.email;
    valueName = widget.userObj.name == null ? '' : widget.userObj.name;
    valuePhone = widget.userObj.phone == null ? '' : widget.userObj.phone;
    isAuthPhone = widget.userObj.phone != null && widget.userObj.phone.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _widthHeightAvatar = SizeConfig.screenWidth / 4;
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a user'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) async {
              if (state is UserCreateLoading) {
                LoadingHud(context).show();
              } else if (state is UserCreateSuccess) {
                BlocProvider.of<UserBloc>(context).add(GetDetailsUser(widget.userObj.id));
              } else if (state is UserCreateError) {
                LoadingHud(context).dismiss();
                DialogCus(context).show(message: 'Error create account');
              } else if (state is GetDetailsError) {
                LoadingHud(context).dismiss();
                print('Get user details: error');
              } else if (state is GetDetailsSuccessfully) {
                LoadingHud(context).dismiss();
                final user = jsonEncode(state.userObj);
                await SharePreferences().saveString(SharePreferenceKey.user, user);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MainPage(userObj: state.userObj,),
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: paddingNavi, right: paddingNavi),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: heightSpaceNormal,),
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
                              FocusScope.of(context).unfocus();
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
                          //full name
                          CustomTextFieldHint(
                              title: 'Full name',
                              value: valueName,
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
                          //email
                          CustomTextFieldHint(
                            title: isAuthPhone ? 'Email(optional)' : 'Email',
                            value: valueEmail,
                            iconData: Icons.email,
                            textInputType: TextInputType.text,
                            isEnable: isAuthPhone,
                            onChanged: (value) {
                              setState(() {
                                valueEmail = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //phone
                          CustomTextFieldHint(
                              title: isAuthPhone ? 'Phone' : 'Phone(optional)',
                              value: valuePhone,
                              iconData: Icons.phone,
                              textInputType: TextInputType.phone,
                              isEnable: !isAuthPhone,
                              onChanged: (value) {
                                setState(() {
                                  valuePhone = value;
                                });
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          //gender
                          TextFieldDropDownHint(
                            hint: 'Gender(optional)',
                            value: valueGender,
                            iconData: Icons.keyboard_arrow_down,
                            onChanged: () async {
                              FocusScope.of(context).unfocus();
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
                          //birthday
                          TextFieldDropDownHint(
                            hint: 'Birthday(optional)',
                            value: valueBirthday,
                            iconData: Icons.calendar_today,
                            onChanged: () {
                              FocusScope.of(context).unfocus();
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
                        ],
                      ),
                    ),
                  ),
                  //button
                  Container(
                    margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                    height: heightButton,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: ButtonCustom(
                        title: 'Create',
                        background: colorActive,
                        onPressed: () {
                          validateDataSubmit();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  validateDataSubmit() {
    print('id: ${widget.userObj.id}');
    if (valueName.length == 0) {
      toast('Please input name');
      return;
    }
    if (isAuthPhone) {
      if (valuePhone.length == 0) {
        toast('Please input phone');
        return;
      }
      final rs = phoneNumberValidator(valuePhone);
      if (rs != null) {
        toast(rs);
        return;
      }
    }

    final user = UserObj();
    user.id = widget.userObj.id;
    user.name = valueName;
    user.email = widget.userObj.email;
    if (widget.userObj.isAuthFb != null && widget.userObj.isAuthFb) {
      user.accessTokenFb = widget.userObj.accessTokenFb;
      user.isAuthFb = true;
    }
    user.phone = valuePhone;
    user.isDoctor = false;
    user.isVerifyPhone = isAuthPhone;
    user.gender = valueGender.contains("Choose") ? "" : valueGender;
    user.birthday = valueBirthday.contains("Choose") ? 0 : dateTimeBirthday.millisecondsSinceEpoch;
    print('data submit ${user.toString()}');
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
