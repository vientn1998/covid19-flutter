import 'dart:async';
import 'package:bloc/bloc.dart';
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
      yield* _mapFetchAllChatByIdToState(event);
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

  Stream<ChatState> _mapFetchAllChatByIdToState(FetchListChat event) async* {
    print('_mapFetchAllChatByIdToState');
    yield LoadingFetchChat();
    try {
      final data = await chatRepository.getChatsById(event.id);
      if (data != null) {
        yield FetchChatSuccess(data);
        print('_mapFetchAllChatByIdToState : ${data.length}');
      } else {
        yield FetchChatError();
        print('error _mapFetchAllChatByIdToState');
      }
    } catch(error) {
      yield FetchChatError();
      print('error _mapFetchAllChatByIdToState: $error');
    }
  }
}
