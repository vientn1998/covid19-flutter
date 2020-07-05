import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/chat_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class SendChat extends ChatEvent {
  ChatModel chatModel;
  SendChat({@required this.chatModel});
  @override
  List<Object> get props => [this.chatModel];
}

class FetchListChat extends ChatEvent {
  String id;
  FetchListChat({@required this.id});
  @override
  List<Object> get props => [this.id];
}
