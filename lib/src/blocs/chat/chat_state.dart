import 'package:cloud_firestore/cloud_firestore.dart';
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
  QuerySnapshot querySnapshot;
  FetchChatSuccess(this.querySnapshot);
  @override
  List<Object> get props => [this.querySnapshot];
}

class FetchChatError extends ChatState {
  @override
  List<Object> get props => [];
}

class UploadFileChatLoading extends ChatState {
  @override
  List<Object> get props => [];
}

class UploadFileChatError extends ChatState {
  @override
  List<Object> get props => [];
}

class UploadFileChatSuccess extends ChatState {
  String url;
  bool isTypeImage;
  UploadFileChatSuccess(this.url, this.isTypeImage);
  @override
  List<Object> get props => [this.url];
}