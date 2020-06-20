import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  CreateDoctorPage({Key key, this.userObj});

  @override
  _CreateDoctorState createState() => _CreateDoctorState();
}

class _CreateDoctorState extends State<CreateDoctorPage> {
  String valueGender, valueBirthday, valueName, valueEmail, valuePhone, valueAddress, valueAbout, valueMajor, valueTimeline;
  int valueExperience = 0;
  DateTime dateTimeBirthday;
  LocationObj _locationObj;
  File _fileAvatar;
  bool isHasAvatar = false;
  final heightSpace = 25.0;
  List<KeyValueObj> listMajor = [];
  List<Asset> images = List<Asset>();
  bool isAuthPhone;
  @override
  void initState() {
    super.initState();
    valueGender = 'Choose gender';
    valueBirthday = 'Choose birthday';
    valueAddress = 'Choose address';
    valueMajor = 'Choose major';
    valueTimeline = 'Choose timeline';
    valueName = widget.userObj.name == null ? '' : widget.userObj.name;
    valueEmail = widget.userObj.email == null ? '' : widget.userObj.email;
    valuePhone = widget.userObj.phone == null ? '' : widget.userObj.phone;
    valueExperience = 0;
    valueAbout = '';
    isAuthPhone = widget.userObj.phone != null && widget.userObj.phone.length > 0;
    fetchDataMajor();
  }

  fetchDataMajor() async {
    BlocProvider.of<MajorBloc>(context).add(FetchMajor());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _widthHeightAvatar = SizeConfig.screenWidth / 4;
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a doctor'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserCreateLoading) {
                    LoadingHud(context).show();
                  } else if (state is UserCreateSuccess) {
                    LoadingHud(context).dismiss();
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ));
                  } else if (state is UserCreateError) {
                    LoadingHud(context).dismiss();
                    DialogCus(context).show(message: 'Error create account');
                  }
                },
              ),
              BlocListener<MajorBloc, MajorState>(
                listener: (context, state) async {
                  if (state is LoadingMajor) {
                    showLoading(context);
                  } else if (state is LoadedSuccessMajor) {
                    final list = state.list;
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
                            height: heightSpace,
                          ),
                          //email
                          CustomTextFieldHint(
                            title: isAuthPhone ? 'Email(optional)' : 'Email',
                            value: valueEmail,
                            textInputType: TextInputType.text,
                            isEnable: isAuthPhone,
                            onChanged: (value) {
                              setState(() {
                                valueEmail = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: heightSpace,
                          ),
                          //phone
                          CustomTextFieldHint(
                              title: isAuthPhone ? 'Phone' : 'Phone(optional)',
                              value: valuePhone,
                              textInputType: TextInputType.phone,
                              isEnable: !isAuthPhone,
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
                            height: heightSpace,
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
                          SizedBox(
                            height: heightSpace,
                          ),
                          //address
                          TextFieldDropDownHint(
                            value: valueAddress,
                            hint: 'Address',
                            iconData: Icons.location_on,
                            onChanged: () async {
                              FocusScope.of(context).unfocus();
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
                          //time
                          TextFieldDropDownHint(
                            value: valueTimeline,
                            hint: 'Timeline',
                            iconData: Icons.calendar_today,
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
                                          child: const Text('All day'), onPressed: () {
                                        Navigator.pop(context, 'All day');
                                      }),
                                      CupertinoActionSheetAction(
                                          child: const Text('Weekend'), onPressed: () {
                                        Navigator.pop(context, 'Weekend');
                                      }),
                                      CupertinoActionSheetAction(
                                          child: const Text('Other'), onPressed: () {
                                        Navigator.pop(context, 'Other');
                                      }),
                                    ]),
                              );
                              setState(() {
                                if (data != null) {
                                  valueTimeline = data;
                                }
                              });
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
                              FocusScope.of(context).unfocus();
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
                          //experience
                          CustomTextFieldHint(
                              title: 'Experience',
                              hint: 'Year',
                              textInputType: TextInputType.phone,
                              onChanged: (value) {
                                setState(() {
                                  valueExperience = int.parse(value);
                                });
                              }),
                          SizedBox(
                            height: 25,
                          ),
                          //image certificate
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Image certificate', style: kBody,),
                              images.length == 0 ? Container() : InkWell(
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child: Icon(Icons.add, size: 24, color: Colors.white,),
                                  decoration: BoxDecoration(
                                      color: colorActive,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  final list = await loadAssets();
                                  setState(() {
                                    if (list.length > 0) {
                                      images = list;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          images.length == 0
                              ? buildAddImage()
                              : buildImageCertificate(),

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

                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(paddingNavi),
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
    );
  }

  validateDataSubmit() {
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
    if (valueAddress.contains('Choose')) {
      toast('Please choose address');
      return;
    }
    if (valueTimeline.contains('Choose')) {
      toast('Please choose timeline');
      return;
    }
    if (valueMajor.contains('Choose')) {
      toast('Please choose major');
      return;
    }
    if (valueExperience == 0) {
      toast('Please input experiences');
      return;
    }
    if (images.length == 0) {
      toast('Please choose image certificate');
      return;
    }
    final user = UserObj();
    user.id = widget.userObj.id;
    user.name = valueName;
    user.email = widget.userObj.email;
    user.phone = valuePhone;
    user.gender = valueGender.contains('Choose') ? "" : valueGender;
    user.timeline = valueTimeline.contains('Choose') ? "" : valueTimeline;
    user.location = valueAddress.contains('Choose') ? null : _locationObj;//location
    user.birthday = valueBirthday.contains('Choose') ? 0 : dateTimeBirthday.millisecondsSinceEpoch;
    user.majors = listMajor.where((element) => element.isSelected).toList();
    user.yearExperience = valueExperience;
    user.about = valueAbout;
    user.isDoctor = true;
    user.isVerifyPhone = isAuthPhone;
    if (widget.userObj.isAuthFb != null && widget.userObj.isAuthFb) {
      user.accessTokenFb = widget.userObj.accessTokenFb;
      user.isAuthFb = true;
    }
    user.imagesCertificate = [];
    print('data submit ${user.toString()}');
    if (_fileAvatar == null) {
      if (widget.userObj.avatar != null && widget.userObj.avatar.isNotEmpty) {
        user.avatar = widget.userObj.avatar;
        BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user, listAsset: images));
      } else {
        BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user, listAsset: images));
      }
    } else {
      BlocProvider.of<UserBloc>(context).add(UserCreate(userObj: user, file: _fileAvatar, listAsset: images));
    }
  }

  buildAddImage() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: backgroundSearch,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
            ),
            child: Icon(Icons.add, size: 40,),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus();
            final list = await loadAssets();
            setState(() {
              if (list.length > 0) {
                images = list;
              }
            });
          },
        )
      ],
    );
  }

  buildImageCertificate() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 10,
      childAspectRatio: 1/1,
      mainAxisSpacing: 10,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Stack(
            children: <Widget>[
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Icon(Icons.close, size: 16,),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<List<Asset>> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: "#9059FF",
          actionBarTitle: "Gallery",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#9059FF",
          selectionLimitReachedText: "You can't select any more.",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    return resultList;
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
                      onTap: () {
                        setState(() {
                          widget.listMajor[index].isSelected = !widget.listMajor[index].isSelected;
                        });
                      },
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
