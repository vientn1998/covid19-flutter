import 'package:equatable/equatable.dart';
import 'package:template_flutter/src/models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class InitialChatState extends ChatState {
  @override
  List<Object> get props => [];
}

class LoadingSendChat extends ChatState {
  @override
  List<Object> get props => [];
}

class ErrorSendChat extends ChatState {
  @override
  List<Object> get props => [];
}

class SendChatSuccess extends ChatState {
  @override
  List<Object> get props => [];
}

class LoadingFetchChat extends ChatState {
  @override
  List<Object> get props => [];
}

class FetchChatSuccess extends ChatState {
  List<ChatGroupDay> list;
  FetchChatSuccess(this.list);
  @override
  List<Object> get props => [this.list];
}

class FetchChatError extends ChatState {
  @override
  List<Object> get props => [];
}
