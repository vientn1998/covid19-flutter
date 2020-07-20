import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/screens/chat/chat_screen.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/dialog_cus.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/widgets/button.dart';
import '../../utils/extension/int_extention.dart';
import '../../utils/string_extension.dart';
import 'package:path/path.dart' as p;
import 'image_viewpager_screen.dart';
import '../../utils/global.dart' as global;
import '../../utils/define.dart';

class ScheduleDetails extends StatefulWidget {
  ScheduleModel scheduleModel;
  bool isHistory = false;
  ScheduleDetails({@required this.scheduleModel, this.isHistory = false});
  @override
  _ScheduleDetailsState createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {

  static const double sizeIcon = 20.0;
  StatusSchedule _statusSchedule;
  UserObj userObj = UserObj();
  GlobalKey globalKeyQrCode = GlobalKey();
  String idQrCode = "";


  updateSchedule(StatusSchedule statusSchedule) {
    BlocProvider.of<ScheduleBloc>(context)
        .add(UpdateSchedule(idSchedule: widget.scheduleModel.id, statusSchedule: statusSchedule));
  }

  getUser() async {
    final dataMap = await SharePreferences().getObject(SharePreferenceKey.user);
    if (dataMap != null) {
      final data = await UserObj.fromJson(dataMap);
      if (data != null) {
        setState(() {
          userObj = data;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    idQrCode = widget.scheduleModel.id + "_qrcode";
    getUser();
    _statusSchedule = widget.scheduleModel.status.toCastStringIntoEnum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Schedule'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(userObj, widget.scheduleModel.sender)
                  ));
            },
          )
        ],
      ),
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleLoading) {
            LoadingHud(context).show();
            return;
          }
          if (state is ScheduleError) {
            LoadingHud(context).dismiss();
            return;
          }
          if (state is UpdateScheduleSuccess) {
            LoadingHud(context).dismiss();
            var result = widget.scheduleModel;
            result.status = _statusSchedule.toCastEnumIntoString();
            Navigator.pop(context, result);
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: boxDecorationDetails(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('User', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.perm_identity, size: sizeIcon, color: colorIcon,),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.name, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.phone, style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.sender.getAddress(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: boxDecorationDetails(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('Schedule', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.adjust, size: sizeIcon, color: colorIcon),
                                              SizedBox(width: heightSpaceSmall,),
                                              Text(widget.scheduleModel.status, style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                              ),),
                                            ],
                                          ),
                                          SizedBox(height: paddingDefault,),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.calendar_today, size: sizeIcon, color: colorIcon),
                                              SizedBox(width: heightSpaceSmall,),
                                              Text(DateTimeUtils().formatDateString(DateTime.fromMillisecondsSinceEpoch(widget.scheduleModel.dateTime)), style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17,
                                              ),),
                                            ],
                                          ),
                                          SizedBox(height: paddingDefault,),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.timer, size: sizeIcon, color: colorIcon),
                                              SizedBox(width: heightSpaceSmall,),
                                              Text(widget.scheduleModel.timeBook.getTypeTimeSchedule(), style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17,
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.scheduleModel.status == StatusSchedule.Approved.toCastEnumIntoString() ? InkWell(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: borderColor)
                                        ),
                                        child: QrImage(
                                          data: idQrCode,
                                          version: QrVersions.auto,
                                          size: 320,
                                          gapless: false,
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShowQrCodeLarge(idSchedule: idQrCode,),
                                            ));
//                                        final fileImage = await _capturePngAndSaveFile(widget.scheduleModel.id);
//                                        if (fileImage != null) {
//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                builder: (context) => ImageViewPager(fileImage: fileImage,),
//                                              ));
//                                        }
                                      },
                                    ) : SizedBox(width: 0,)
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.mode_edit, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.note.stringValue(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: backgroundSurvey
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: paddingDefault,),
                    Container(
                      decoration: boxDecorationDetails(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(heightSpaceSmall, heightSpaceSmall, heightSpaceSmall, 5),
                            child: Text('Doctor', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(heightSpaceSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.perm_identity, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.receiver.name, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Text(widget.scheduleModel.receiver.phone.stringValue(), style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                  ],
                                ),
                                SizedBox(height: paddingDefault,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.location_on, size: sizeIcon, color: colorIcon),
                                    SizedBox(width: heightSpaceSmall,),
                                    Expanded(
                                      child: Text(widget.scheduleModel.receiver.getAddress().stringValue(), style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: backgroundSurvey
                                      ),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.isHistory ? buildActionHistory() : global.isDoctor ? buildActionDoctor() : buildActionUser()
            ],
          ),
        ),
      ),
    );
  }

  buildActionDoctor() {
    return widget.scheduleModel.status == StatusSchedule.New.toCastEnumIntoString()
        ? Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  margin:
                      EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                  height: heightButton,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                    child: ButtonCustom(
                      title: 'Cancel',
                      background: colorActive,
                      onPressed: () async {
                        final note = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return MyDialogCancelSchedule();
                            }) as String;
                        print('note: $note');
                        if (note != null && note.length > 0) {
                          updateSchedule(StatusSchedule.Canceled);
                          setState(() {
                            _statusSchedule = StatusSchedule.Canceled;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: paddingDefault,
              ),
              Flexible(
                child: Container(
                  margin:
                      EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                  height: heightButton,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                    child: ButtonCustom(
                      title: 'Approve',
                      background: colorActive,
                      onPressed: () {
                        setState(() {
                          _statusSchedule = StatusSchedule.Approved;
                        });
                        updateSchedule(StatusSchedule.Approved);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        : widget.scheduleModel.status == StatusSchedule.Approved.toCastEnumIntoString()
            ? Container(
                margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Done',
                    background: colorActive,
                    onPressed: () {
                      updateSchedule(StatusSchedule.Done);
                      setState(() {
                        _statusSchedule = StatusSchedule.Done;
                      });
                    },
                  ),
                ),
              )
            : SizedBox(
                height: 1,
              );
  }

  buildActionUser() {
    return _statusSchedule == StatusSchedule.New
        ? Container(
            margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
            height: heightButton,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
              child: ButtonCustom(
                title: 'Cancel',
                background: colorActive,
                onPressed: () async {
                  final note = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return MyDialogCancelSchedule();
                      }) as String;
                  print('note: $note');
                  if (note != null && note.length > 0) {
                    updateSchedule(StatusSchedule.Canceled);
                    setState(() {
                      _statusSchedule = StatusSchedule.Canceled;
                    });
                  }
                },
              ),
            ),
          )
        : _statusSchedule == StatusSchedule.Done
        ? Container(
                margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Rate',
                    background: colorActive,
                    onPressed: () {
                      updateSchedule(StatusSchedule.Done);
                      setState(() {
                        _statusSchedule = StatusSchedule.Done;
                      });
                    },
                  ),
                ),
              )
            : SizedBox(
      height: 1,
    );
  }

  buildActionHistory() {
    return widget.scheduleModel.status == StatusSchedule.Done.toCastEnumIntoString()
            ? Container(
                margin: EdgeInsets.only(top: paddingNavi, bottom: paddingNavi),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Rate',
                    background: colorActive,
                    onPressed: () {
                      updateSchedule(StatusSchedule.Done);
                      setState(() {
                        _statusSchedule = StatusSchedule.Done;
                      });
                    },
                  ),
                ),
              )
            : SizedBox(
                height: 1,
              );
  }

  Future<File> _capturePngAndSaveFile(String fileName) async {
    RenderRepaintBoundary boundary = globalKeyQrCode.currentContext.findRenderObject();
//    if (boundary.debugNeedsPaint) {
//      Timer(Duration(seconds: 1), () => _capturePngAndSaveFile("12"));
//      return null;
//    }
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print("bytes: $pngBytes");
    final tempDir = (await getTemporaryDirectory());
    final dbPath = p.join(tempDir.path, '$fileName.png');
    File qrCodeFile = await File(dbPath);
    print("real path : ${qrCodeFile.path}");
//    if (qrCodeFile.existsSync()) {
//      print("existsSync : true");
//      return qrCodeFile;
//    } else {
//      print("existsSync : false");
//      await qrCodeFile.writeAsBytes(pngBytes);
//      return qrCodeFile;
//    }
    await qrCodeFile.writeAsBytes(pngBytes);
    return qrCodeFile;
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  boxDecorationDetails() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ]);
  }
}

class ShowQrCodeLarge extends StatefulWidget {
  String idSchedule;
  ShowQrCodeLarge({@required this.idSchedule});

  @override
  _ShowQrCodeLargeState createState() => _ShowQrCodeLargeState();
}

class _ShowQrCodeLargeState extends State<ShowQrCodeLarge> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('View QrCode'),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: QrImage(
          data: widget.idSchedule,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
      ),
    );
  }
}


class MyDialogCancelSchedule extends StatefulWidget {

  @override
  _MyDialogCancelScheduleState createState() => _MyDialogCancelScheduleState();
}

class _MyDialogCancelScheduleState extends State<MyDialogCancelSchedule> {

  String note;
  TextEditingController textEditingController;

  @override
  void initState() {
    note = '';
    textEditingController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      elevation: 1,
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 35,),
                Expanded(
                  child: Text('Reason', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor
                  ), textAlign: TextAlign.center,),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(paddingDefault, 0, paddingDefault, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: backgroundSearch,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 1, color: backgroundTextInput)
                ),
                child: TextField(
                  maxLines: 6,
                  minLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  controller: textEditingController,
                  onChanged: (value) {
                    setState(() {
                      note = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  ),
                ),
              ),
            ),
            SizedBox(height:5,),
            Container(
              margin: EdgeInsets.all(paddingDefault),
              height: heightButton,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: ButtonCustom(
                  title: 'Done',
                  background: colorActive,
                  onPressed: () async {
                    if (note.length > 0) {
                      Navigator.pop(context, note);
                      FocusScope.of(context).unfocus();
                    } else {
                      toast('Please input note', gravity: ToastGravity.BOTTOM);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}