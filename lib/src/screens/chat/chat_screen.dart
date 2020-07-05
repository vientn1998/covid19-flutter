import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:template_flutter/src/blocs/chat/bloc.dart';
import 'package:template_flutter/src/models/chat_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/date_time.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';
import 'package:template_flutter/src/utils/size_config.dart';

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

  @override
  void initState() {
    isFirstFetchData = false;
    isChooseImage = false;
    super.initState();
    focusNode.addListener(onFocusChange);
    day = DateTime(dateTime.year, dateTime.month, dateTime.day);
    getData();
    KeyboardVisibility.onChange.listen((visible) {
      print('isKeyboardAppear : $visible');
      if (visible) {
        isChooseImage = false;
        if (listScrollController != null && listScrollController.hasClients) {
          Timer(Duration(milliseconds: 300), () {
            listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          });
        }
      } else {
        if (listScrollController != null && listScrollController.hasClients) {
          Timer(Duration(milliseconds: 300), () {
            listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.fastOutSlowIn);
          });
        }
      }
    });
    _bloc.start();
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
                    }
                  },
                  buildWhen: (previous, current) {
                    if (current is LoadingSendChat || current is LoadingFetchChat || current is FetchListRealTimeChat) {
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
              KeyboardAware(
                builder: (context, keyboardConfig) {
                  print('keyboardConfig ${keyboardConfig.isKeyboardOpen}');
                  if (keyboardConfig.isKeyboardOpen) {
                    heightKeyboard = keyboardConfig.keyboardHeight + 37;
                    return SizedBox(height: 7,);
                  } else {
                    if (isChooseImage) {
                      return SizedBox(height: heightKeyboard,);
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
                        child: Padding(
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
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
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

  buildActionSend({@required IconData icon, double size = 26, Function function}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Icon(icon, color: Colors.red, size: size,),
      ),
      onTap: function,
    );
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
            buildActionSend(icon: Icons.camera_alt),
            buildActionSend(icon: Icons.image, function: () {
              textEditingController.clear();
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

  sendMessage(String message) {
    ChatModel chatModel = ChatModel();
    chatModel.dateTime = DateTime.now().millisecondsSinceEpoch;
    chatModel.day = day.millisecondsSinceEpoch;
    chatModel.idReceiver = widget.userReceiver.id;
    chatModel.idSender = widget.userSender.id;
    chatModel.content = message;
    chatModel.idGroup = idChat;
    chatModel.id = DateTime.now().millisecondsSinceEpoch.toString();
    chatModel.type = chatModel.getType();
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