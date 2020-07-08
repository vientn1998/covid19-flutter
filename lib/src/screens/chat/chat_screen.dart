import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:template_flutter/src/blocs/chat/bloc.dart';
import 'package:template_flutter/src/models/chat_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/size_config.dart';
import 'package:template_flutter/src/widgets/button.dart';
import 'dart:io';
import 'crop_image_screen.dart';

class ChatPage extends StatefulWidget {

  UserObj userReceiver;
  UserObj userSender;

  ChatPage(this.userSender ,this.userReceiver);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController(initialScrollOffset: 0);
  final FocusNode focusNode = FocusNode();
  bool isFocus = false, isFirstFetchData, isChooseImage;
  double deviceWidth, deviceHeight;
  String idChat = '';
  String idSender = '';
  final dateTime = DateTime.now();
  DateTime day;
  double heightKeyboard = 0.0;
  KeyboardBloc _bloc = KeyboardBloc();
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  int currentSeconds = 0;
  String pathRecorder = '', durationAudio = '';
  Timer _timer;
  AudioPlayer audioPlayer;
  @override
  void initState() {
    isFirstFetchData = false;
    isChooseImage = false;
    super.initState();
    audioPlayer = AudioPlayer();
    focusNode.addListener(onFocusChange);
    day = DateTime(dateTime.year, dateTime.month, dateTime.day);
    getData();
    KeyboardVisibility.onChange.listen((visible) {
      print('isKeyboardAppear : $visible');
      if (visible) {
        isChooseImage = false;
//        if (listScrollController != null && listScrollController.hasClients) {
//          Timer(Duration(milliseconds: 300), () {
//            listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
//          });
//        }
      } else {
//        if (listScrollController != null && listScrollController.hasClients) {
//          Timer(Duration(milliseconds: 300), () {
//            listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.fastOutSlowIn);
//          });
//        }
      }
    });
    _bloc.start();
    _initRecorderAudio();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    listScrollController.dispose();
    _bloc.dispose();
  }

  getData() async {
    if (widget.userSender.isDoctor) {
      idSender = widget.userReceiver.id;
      idChat = '${widget.userReceiver.id}${widget.userSender.id}';
    } else {
      idSender = widget.userSender.id;
      idChat = '${widget.userSender.id}${widget.userReceiver.id}';
    }
    print('idChat: $idChat');
    BlocProvider.of<ChatBloc>(context).add(FetchListChat(id: idChat));
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      print('onFocusChange hasFocus');
      setState(() {
        isFocus = true;
      });
    } else {
      print('onFocusChange not hasFocus');
      setState(() {
        isFocus = false;
      });
    }
  }

  _initRecorderAudio() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_chat';
        final appDocDirectory = await getApplicationDocumentsDirectory();


        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path + customPath +
            DateTime.now().millisecondsSinceEpoch.toString() +".wav";
        pathRecorder = customPath;
        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        setState(() {
          _currentStatus = RecordingStatus.Initialized;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      const tick = const Duration(seconds: 1);
      if (!mounted) {
        return;
      }
      _timer = Timer.periodic(tick, (timer) {
        setState(() {
          currentSeconds = timer.tick;
        });
      });
        setState(() {
          _currentStatus = RecordingStatus.Recording;
        });
    } catch (e) {
      print(e);
    }
  }

  Future<File> _send() async {
    var result = await _recorder.stop();
    File file = File(result.path);
    _timer.cancel();
    setState(() {
      currentSeconds = 0;
      _currentStatus = result.status;
    });
    return file;
  }

  _cancel() async {
    var result = await _recorder.stop();
    print('_cancel ${result.status.toString()}');
    _timer.cancel();
    setState(() {
      _currentStatus = result.status;
      currentSeconds = 0;
    });
    print('_cancel ${_currentStatus.toString()}');
    File file = File(pathRecorder);
    file.deleteSync();
    if (file.existsSync()) {
      print('file delete success');
    }
    _initRecorderAudio();
  }

  String get timerText => currentSeconds == 0 ? '00:00`' :
      '${((currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((currentSeconds) % 60).toString().padLeft(2, '0')}';

  playAudio(String url) async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      print('play success');
    } else {
      print('play failure');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.userReceiver.name, style: TextStyle(
                  fontSize: 16
              ),),
              SizedBox(height: 2,),
              Text('Active', style: TextStyle(
                fontSize: 12
              ),),
            ],
          ),
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () {
//
//            },
//          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {

              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is FetchChatSuccess) {
                      if (listScrollController != null) {
                        Timer(Duration(milliseconds: 100), () {
                          print('isFirstFetchData : $isFirstFetchData');
                          listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: isFirstFetchData ? Duration(milliseconds: 100) : Duration(microseconds: 1), curve: Curves.easeInOut);
                          isFirstFetchData = true;
                        });
                      }
                    } else if (state is UploadFileChatError) {
                      LoadingHud(context).dismiss();
                    } else if (state is UploadFileChatLoading) {
                      LoadingHud(context).show();
                    } else if (state is UploadFileChatSuccess) {
                      LoadingHud(context).dismiss();
                      if (state.isTypeImage) {
                        sendMessage("",urlImage: state.url, isTypeImage: true);
                      } else {
                        sendMessage("",urlImage: state.url, isTypeImage: false);
                      }
                    }
                  },
                  buildWhen: (previous, current) {
                    if (current is LoadingSendChat || current is LoadingFetchChat || current is FetchListRealTimeChat) {
                      return false;
                    }
                    if (current is UploadFileChatLoading || current is UploadFileChatError || current is UploadFileChatSuccess) {
                      return false;
                    }
                    if (current is SendChatSuccess) {
                      textEditingController.text = '';
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is LoadingFetchChat) {
                      return Text('Loading...');
                    }
                    if (state is FetchChatSuccess) {
                      print('FetchChatSuccess abc');
                      List<ChatGroupDay> list = [];
                      List<ChatModel> listChat = [];
                      List<int> listDay = [];
                      final querySnapshot = state.querySnapshot;
                      final item = querySnapshot.documents.map((documentChange) {
                        return ChatModel.fromSnapshot(documentChange);
                      }).toList();

                      print('item: ${item.length}');
                      print('listChat: ${listChat.length}');
                      listChat.addAll(item);

                      listChat.forEach((schedule) {
                        if (!listDay.any((element) => element == schedule.day)) {
                          listDay.add(schedule.day);
                        }
                      });
                      print(listDay);
                      Future.wait(listDay.map((item) async {
                        final ls = listChat.where((element) {
                          return item == element.day;
                        }).toList();
                        ls.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                        var scheduleDay = ChatGroupDay(day: item, listChat: ls);
                        list.add(scheduleDay);
                      }));
                      list.sort((a, b) => a.day.compareTo(b.day));
                      var idMessLast = '';
//                      Future.wait(listChat.map((item) async{
//                        if (item.idReceiver != idSender) {
//                          idMessLast = item.id;
//                        }
//                      }));
//                      print(idMessLast);
                      return ListView.builder(
                        controller: listScrollController,
                        shrinkWrap: true,

                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildDayHeader(list[index], idMessLast: idMessLast);
                        },
                        itemCount: list.length,
                      );
                    }
                    return Text('Loading...');
                  },

                ),
              ),
              SizedBox(height: 7,),
              buildInput(),
//              SizedBox(height: 7,),
              KeyboardAware(
                builder: (context, keyboardConfig) {
                  if (keyboardConfig.isKeyboardOpen) {
                    heightKeyboard = keyboardConfig.keyboardHeight + 37;
                    return SizedBox(height: 7,);
                  } else {
                    if (isChooseImage) {
                      return buildWidgetRecorder();
                    } else {
                      return SizedBox(height: 7,);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildWidgetRecorder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: heightKeyboard + 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(child: Text(currentSeconds == 0 ? '00: 00' : timerText, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: borderColor),)),
          ),
          if (_currentStatus != null && _currentStatus == RecordingStatus.Initialized || _currentStatus == RecordingStatus.Stopped)
            Container(
              margin: EdgeInsets.all(paddingDefault),
              height: heightButton,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: ButtonCustom(
                  title: 'Recorder',
                  background: Colors.red,
                  borderRadius: 16,
                  onPressed: () {
                    _start();
                  },
                ),),
          ) else Row(
            children: <Widget>[
              Expanded(child: Container(
                margin: EdgeInsets.all(paddingDefault),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Cancel',
                    background: Colors.blueGrey,
                    borderRadius: 16,
                    onPressed: () {
                      _cancel();
                    },
                  ),),
              ),),
              Expanded(child: Container(
                margin: EdgeInsets.all(paddingDefault),
                height: heightButton,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: ButtonCustom(
                    title: 'Send',
                    background: Colors.blue,
                    borderRadius: 16,
                    onPressed: () async {
                      durationAudio = timerText;
                      final file = await _send();
                      print('duration file recorder: $durationAudio');
                      print('path file recorder: ${file.path}');
                      print('size file recorder: ${ await file.length()}');
                      focusNode.requestFocus();
                      BlocProvider.of<ChatBloc>(context).add(UploadImage(folder: idChat, file: file, isImage: false));
                    },
                  ),),
              ),),
            ],
          ),

        ],
      ),
    );
  }

  buildDayHeader(ChatGroupDay chatGroupDay, {String idMessLast = ''}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        buildItemTime(DateTime.fromMillisecondsSinceEpoch(chatGroupDay.day)),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            final item = chatGroupDay.listChat[index];
            if (item.idSender == widget.userSender.id) {
              return buildItemRightMessage(item);
            } else {
              if (item.id == idMessLast) {
                return buildItemLeftMessage(item, isShowAvatar: true);
              } else {
                return buildItemLeftMessage(item);
              }
            }
          },
          itemCount: chatGroupDay.listChat.length,
        )
      ],
    );
  }

  buildItemTime(DateTime dateTime) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateTimeUtils().formatDateString(dateTime), style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              color: Colors.blueGrey
            ),)
          ],
        ),
      ],
    );
  }

  buildItemLeftMessage(ChatModel chatModel, {bool isShowAvatar = false}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              true ? Icon(Icons.account_circle) : SizedBox(width: 24,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 5, deviceWidth / 4, 0),
                        decoration: BoxDecoration(
                          color: backgroundTextInput,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: chatModel.url.length > 0 ? Container(
//                                height: 100,
//                                width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: chatModel.url,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(child: CupertinoActivityIndicator(), width: 100, height: 100,),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(Icons.image),
                              ),
                            ),
                          ),
                        ) : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(chatModel.content, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                          ),),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildItemRightMessage(ChatModel chatModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(deviceWidth / 4, 5, 10, 0),
                        decoration: BoxDecoration(
                          color: chatModel.type == 'image' ? Colors.white : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: chatModel.type == 'image'
                            ? Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: chatModel.url,
                                    fit: BoxFit.fill,
                                    progressIndicatorBuilder: (context, url, progress) {
                                      print("progress ${progress.progress}");
                                      if (progress != null && progress.progress != null && progress.progress > 0.99) {
                                        Timer(Duration(milliseconds: 500), () {
                                          listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                                        });
                                      }
                                      return Container(child: CupertinoActivityIndicator(), width: 100, height: 100,);
                                    },
                                    errorWidget: (context, url, error) => Center(
                                      child: Icon(Icons.image),
                                    ),
                                  ),
                                ),
                        )
                            : chatModel.type == 'audio'
                            ? BuildBubbleAudio(chatModel: chatModel,) : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(chatModel.content, style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildBubble(ChatModel chatModel) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
              onTap: () async {
                await audioPlayer.play(chatModel.url);
              },
            ),
            SizedBox(
              width: 50,
            ),
            Text(chatModel.durationAudio,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
          ],
        ));
  }

  buildActionSend({@required IconData icon, double size = 26, Function function}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Icon(icon, color: Colors.red, size: size,),
      ),
      onTap: function,
    );
  }

  Future<Null> _takeImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      _cropImage(imageFile);
    }
  }

  Future<Null> _pickImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _cropImage(imageFile);
    }
  }

  Future<Null> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      BlocProvider.of<ChatBloc>(context).add(UploadImage(folder: idChat, file: croppedFile, isImage: true));
    }
  }

  Widget buildInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        isFocus ? buildActionSend(icon: Icons.arrow_forward_ios, size: 20, function: () {
          setState(() {
            isFocus = false;
          });
        }) : Row(
          children: <Widget>[
            buildActionSend(icon: Icons.add_circle),
            buildActionSend(icon: Icons.camera_alt, function: () {
              _takeImage();
            }),
            buildActionSend(icon: Icons.image, function: () async {
//              textEditingController.clear();
//              if (isChooseImage) {
//                focusNode.requestFocus();
//              } else {
//                focusNode.unfocus();
//              }
//              isChooseImage = !isChooseImage;
              focusNode.unfocus();
              _pickImage();
            }),
            buildActionSend(icon: Icons.keyboard_voice, function: () {
              if (isChooseImage) {
                focusNode.requestFocus();
              } else {
                focusNode.unfocus();
              }
              isChooseImage = !isChooseImage;
            }),
          ],
        ),
        SizedBox(width: 15,),
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            textCapitalization: TextCapitalization.sentences,
            focusNode: focusNode,
            autofocus: false,
            obscureText: false,
            autocorrect: false,
            minLines: 1,
            maxLines: 5,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400
            ),
            onChanged: (v) {
              if (!isFocus) {
                setState(() {
                  isFocus = true;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              hintText: 'Text',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              filled: true,
              fillColor: borderColor,
              border: border,
              focusedBorder: border,
              enabledBorder: border,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.send, color: Colors.red,),
              onPressed: () {
                sendMessage(textEditingController.text);
                print('object');
              },
            ),
          ],
        )
      ],
    );
  }

  static OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: Colors.transparent),
  );

  sendMessage(String message, {String urlImage = "", bool isTypeImage = true}) {
    ChatModel chatModel = ChatModel();
    chatModel.dateTime = DateTime.now().millisecondsSinceEpoch;
    chatModel.day = day.millisecondsSinceEpoch;
    chatModel.idReceiver = widget.userReceiver.id;
    chatModel.idSender = widget.userSender.id;
    chatModel.content = message;
    chatModel.idGroup = idChat;
    chatModel.url = urlImage;
    chatModel.id = DateTime.now().millisecondsSinceEpoch.toString();
    if (message != null && message.length > 0) {
      chatModel.type = 'text';
    } else if (isTypeImage) {
      chatModel.type = 'image';
    } else {
      chatModel.type = 'audio';
      chatModel.durationAudio = durationAudio;
    }
//    chatModel.type = chatModel.getType();
    var documentReference = Firestore.instance
        .collection('Chats')
        .document(idChat)
        .collection(idChat)
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        chatModel.toJson(),
      );
    });
    textEditingController.clear();
//    BlocProvider.of<ChatBloc>(context).add(SendChat(chatModel: chatModel));
  }
}

class KeyboardBloc {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  StreamController<double> _streamController = StreamController<double>();
  Stream<double> get stream => _streamController.stream;

  KeyboardUtils get keyboardUtils => _keyboardUtils;

  int _idKeyboardListener;

  void start() {
    _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
          _streamController.sink.add(_keyboardUtils.keyboardHeight);
        }, willShowKeyboard: (double keyboardHeight) {
          _streamController.sink.add(keyboardHeight);
        }));
  }

  void dispose() {
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
    _streamController.close();
  }
}

class BuildBubbleAudio extends StatefulWidget {
  ChatModel chatModel;
  BuildBubbleAudio({chatModel}) : assert(chatModel != null);
  @override
  _BuildBubbleAudioState createState() => _BuildBubbleAudioState();
}

class _BuildBubbleAudioState extends State<BuildBubbleAudio> {
  AudioPlayer audioPlayer = AudioPlayer();
  ChatModel chatModel;
  @override
  void initState() {
    super.initState();
    chatModel = widget.chatModel;
    audioPlayer.onDurationChanged.listen((duration) {
      print('max duration $duration');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('chat model : ${chatModel.toString()}');
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
              onTap: () async {
                await audioPlayer.play(widget.chatModel.url);
              },
            ),
            SizedBox(
              width: 50,
            ),
            Text('',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
          ],
        ));
  }
}
