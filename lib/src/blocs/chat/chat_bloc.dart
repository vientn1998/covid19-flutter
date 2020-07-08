import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/src/models/chat_model.dart';
import 'package:template_flutter/src/repositories/chat_repository.dart';
import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository);

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is SendChat) {
      yield* _mapCreateToState(event);
    } else if (event is FetchListChat) {
      yield* _mapFetchAllRealmTimeChatByIdToState(event);
    } else if (event is FetchListRealTimeChat) {
      yield* _mapFetchAllChatByIdToState(event);
    } else if (event is InitChatEvent) {
      yield InitialChatState();
    } else if (event is UploadImage) {
      yield* _mapUploadImageToState(event);
    }
  }

  Stream<ChatState> _mapCreateToState(SendChat event) async* {
    yield LoadingSendChat();
    final isSuccess = await chatRepository.sendMessage(event.chatModel);
    if (isSuccess != null && isSuccess == true) {
      yield SendChatSuccess();
    } else {
      yield ErrorSendChat();
    }
  }

  Stream<ChatState> _mapFetchAllRealmTimeChatByIdToState(FetchListChat event) async* {
    print('_mapFetchAllRealmTimeChatByIdToState');
    yield LoadingFetchChat();
    try {
      chatRepository.getChatsRealmTimeById(event.id).listen((querySnapshot) {
        return add(FetchListRealTimeChat(querySnapshot: querySnapshot));
      });
    } catch(error) {
      yield FetchChatError();
      print('error _mapFetchAllRealmTimeChatByIdToState: $error');
    }
  }

  Stream<ChatState> _mapFetchAllChatByIdToState(FetchListRealTimeChat event) async* {
    print('_mapFetchAllChatByIdToState');
    try {
      yield FetchChatSuccess(event.querySnapshot);
    } catch(error) {
      yield FetchChatError();
      print('error _mapFetchAllChatByIdToState: $error');
    }
  }

  Stream<ChatState> _mapUploadImageToState(UploadImage event) async* {
    yield UploadFileChatLoading();
    print('_mapUploadImageToState');
    try {
      final urlImage = await chatRepository.uploadImageToServer(event.folder, event.file);
      if (urlImage != null && urlImage.length > 0) {
        yield UploadFileChatSuccess(urlImage, event.isImage);
      } else {
        yield UploadFileChatError();
      }
    } catch(error) {
      yield UploadFileChatError();
    }
  }
}
