import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:template_flutter/src/blocs/major/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/location_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/image_picker.dart';
import 'package:template_flutter/src/utils/size_config.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/utils/validator.dart';
import 'package:template_flutter/src/widgets/button.dart';
import 'package:template_flutter/src/widgets/navigation_cus.dart';
import 'package:template_flutter/src/widgets/text_field.dart';
import 'package:template_flutter/src/widgets/text_field_dropdown.dart';

import '../main_screen.dart';
import 'search_location_screen.dart';

class CreateDoctorPage extends StatefulWidget {

  final UserObj userObj;
  final Covid19Dao _covid19dao = Covid19Dao();

  CreateDoctorPage({Key key, this.userObj});

  @override
  _CreateDoctorState createState() => _CreateDoctorState();
}

class _CreateDoctorState extends State<CreateDoctorPage> {
  String valueGender, valueBirthday, valueName, valueEmail, valuePhone, valueAddress, valueAbout, valueMajor;
  int valueExperience = 0;
  DateTime dateTimeBirthday;
  LocationObj _locationObj;
  File _fileAvatar;
  bool isHasAvatar = false;
  final heightSpace = 25.0;
  List<KeyValueObj> listMajor = [];
  Covid19Dao _covid19dao = Covid19Dao();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();
    valueGender = 'Choose gender';
    valueBirthday = 'Choose birthday';
    valueAddress = 'Choose address';
    valueMajor = 'Choose major';
    valueName = widget.userObj.name;
    valueEmail = widget.userObj.email;
    valuePhone = '';
    valueExperience = 0;
    valueAbout = '';
    checkData();
  }

  checkData() async {
    BlocProvider.of<MajorBloc>(context).add(FetchMajor());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _widthHeightAvatar = SizeConfig.screenWidth / 4;
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<UserBloc, UserState>(
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

              ),
              BlocListener<MajorBloc, MajorState>(
                listener: (context, state) async {
                  if (state is LoadingMajor) {
                    showLoading(context);
                  } else if (state is LoadedSuccessMajor) {
                    final list = state.list;
                    print('count: ${list.length}');
                    setState(() {
                      listMajor.addAll(list);
                    });
                    dismissLoading(context);
                  } else if (state is LoadedErrorMajor) {
                    dismissLoading(context);
                  }
                },
              )
            ],
            child: Column(
              children: <Widget>[
                NavigationCus(title: 'Create a doctor',isHidenIconRight: true,functionBack: () {
                  Navigator.pop(context);
                },),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(paddingNavi),
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
                            height: heightSpace,
                          ),
                          //email
                          CustomTextFieldHint(
                            title: 'Email',
                            value: valueEmail,
                            textInputType: TextInputType.text,
                            isEnable: false,
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                          CustomTextFieldHint(
                              title: 'Phone',
                              textInputType: TextInputType.phone,
                              onChanged: (value) {
                                setState(() {
                                  valuePhone = value;
                                });
                              }),
                          SizedBox(
                            height: heightSpace,
                          ),
                          //gender
                          TextFieldDropDownHint(
                            value: valueGender,
                            hint: 'Gender(optional)',
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
                            height: heightSpace,
                          ),
                          //address
                          TextFieldDropDownHint(
                            value: valueAddress,
                            hint: 'Address',
                            iconData: Icons.location_on,
                            onChanged: () async {
                              final location = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchLocationPage(),
                                  )) as LocationObj;
                              if (location != null) {
                                setState(() {
                                  _locationObj = location;
                                  valueAddress = location.address;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                          //major
                          TextFieldDropDownHint(
                            value: valueMajor,
                            hint: 'Major',
                            iconData: Icons.keyboard_arrow_down,
                            onChanged: () async {
                              final count = await showDialog(
                                context: context,
                                builder: (context) {
                                  return MyDialogMajor(listMajor);
                                },
                              );
                              print('count $count');
                              if (count > 0) {
                                setState(() {
                                  valueMajor = '$count item';
                                });
                              } else {
                                setState(() {
                                  valueMajor = 'Choose major';
                                });
                              }

                            },
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                          FlatButton(
                            child: Text('add'),
                            onPressed: () {
                              loadAssets();
                            },
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                          //experience
                          CustomTextFieldHint(
                              title: 'Experiences(year)',
                              hint: '0',
                              textInputType: TextInputType.phone,
                              onChanged: (value) {
                                setState(() {
                                  valueExperience = int.parse(value);
                                });
                              }),
                          SizedBox(
                            height: heightSpace,
                          ),
                          //about
                          CustomTextFieldHint(
                              title: 'About(optional)',
                              maxLine: 3,
                              height: 100,
                              textInputType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  valueAbout = value;
                                });
                              }),
                          SizedBox(
                            height: heightSpace,
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
                                  if (valueName.length == 0) {
                                    toast('Please input name');
                                    return;
                                  }
                                  if (valuePhone.length == 0) {
                                    toast('Please input phone');
                                    return;
                                  }
                                  final rs = phoneNumberValidator(valuePhone);
                                  if (rs != null) {
                                    toast(rs);
                                    return;
                                  }
                                  if (valueExperience == 0) {
                                    toast('Please input experiences');
                                  }
                                  if (valueAddress.length == 0) {
                                    toast('Please input address');
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Gallery",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
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

class MyDialogMajor extends StatefulWidget {
  List<KeyValueObj> listMajor;
  MyDialogMajor(this.listMajor);
  @override
  _MyDialogMajorState createState() => _MyDialogMajorState();
}

class _MyDialogMajorState extends State<MyDialogMajor> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.listMajor.where((element) => element.isSelected).length;
    return AlertDialog(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text('Choose major', style: kTitleBold, textAlign: TextAlign.center,),
      titlePadding: EdgeInsets.only(top: 15, bottom: 10),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22)
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = widget.listMajor[index];
                    return ListTile(
                      title: new Text(item.value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                      leading: Checkbox(
                        value: item.isSelected,
                        onChanged: (value) {
                          print('change: $index $value');
                          setState(() {
                            widget.listMajor[index].isSelected = value;
                          });
                        },
                      ),
                    );
                  },
                  itemCount: widget.listMajor.length,
                  shrinkWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 42,
                        child: FlatButton(
                          color: colorActive,
                          textColor: Colors.white,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                  style: BorderStyle.solid
                              )
                          ),
                          child: Text("Done ${count > 0 ? '$count item' : ''}", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),),
                          onPressed: () {
                            Navigator.pop(context, count);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}


//child: SingleChildScrollView(
//child: Column(
//mainAxisAlignment: MainAxisAlignment.start,
//children: buildCheckBoxMajor(),
//),
//),