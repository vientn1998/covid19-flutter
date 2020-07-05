import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  ChatPage(this.userReceiver);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserObj userObj = UserObj();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isFocus = false;
  double deviceWidth, deviceHeight;
  String idChat = '';
  final dateTime = DateTime.now();
  DateTime day;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    day = DateTime(dateTime.year, dateTime.month, dateTime.day);
    getUser();
  }

  getUser() async {
    final dataMap = await SharePreferences().getObject(SharePreferenceKey.user);
    if (dataMap != null) {
      final data = UserObj.fromJson(dataMap);
      if (data != null) {
        setState(() {
          userObj = data;
        });
        if (userObj.isDoctor) {
          idChat = '${widget.userReceiver.id}${userObj.id}';
        } else {
          idChat = '${userObj.id}${widget.userReceiver.id}';
        }
        print('idChat: $idChat');
        BlocProvider.of<ChatBloc>(context).add(FetchListChat(id: idChat));
      }
    }
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
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is FetchChatSuccess) {

                    }
                  },
                  buildWhen: (previous, current) {
                    print(previous);
                    print(current);
                    if (current is LoadingSendChat || current is LoadingFetchChat) {
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
                      final list = state.list;
                      return ListView.builder(
                        controller: listScrollController,
                        shrinkWrap: true,

                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildDayHeader(list[index]);
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
              SizedBox(height: 7,)
            ],
          ),
        ),
      ),
    );
  }

  sendMessage(String message) {
    ChatModel chatModel = ChatModel();
    chatModel.dateTime = DateTime.now().millisecondsSinceEpoch;
    chatModel.day = day.millisecondsSinceEpoch;
    chatModel.idReceiver = widget.userReceiver.id;
    chatModel.idSender = userObj.id;
    chatModel.content = message;
    chatModel.idGroup = idChat;
    chatModel.type = chatModel.getType();
    BlocProvider.of<ChatBloc>(context).add(SendChat(chatModel: chatModel));
  }

  buildDayHeader(ChatGroupDay chatGroupDay) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        buildItemTime(DateTime.fromMillisecondsSinceEpoch(chatGroupDay.day)),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            final item = chatGroupDay.listChat[index];
            if (item.idSender == userObj.id) {
              return buildItemRightMessage(item);
            } else {
              return buildItemLeftMessage(item);
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

  buildItemLeftMessage(ChatModel chatModel) {
//    if (isScroll) {
//      Timer(Duration(milliseconds: 1), () {
//        listScrollController?.animateTo(listScrollController?.position?.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
//      });
//    }
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
              Icon(Icons.account_circle),
              Expanded(
                child: Container(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildItemRightMessage(ChatModel chatModel) {
    return Column(
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
                child: Container(
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
                      ),),
                    )
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
            buildActionSend(icon: Icons.image),
          ],
        ),
        SizedBox(width: 15,),
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            textCapitalization: TextCapitalization.words,
            focusNode: focusNode,
            autofocus: true,
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
}
