import 'dart:async';

import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

import '../../services/chatbot_services.dart';
import '../models/chatbot_model.dart';
import 'chat_bloc.dart';

// part 'chat_event.dart';
// part 'chat_state.dart';

class RecycleBloc extends Bloc<ChatEvent, ChatState> {
  RecycleBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  List<ChatMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(ChatMessageModel(role: "user", parts: [
      ChatPartModel(
          text:
              "i have an old ${event.inputMessage} that i dont use what can i make from it, and could you give tutorials from youtube or step by step instructions")
    ]));
    emit(ChatSuccessState(messages: messages));
    generating = true;
    String generatedText =
        await ChatBotService.chatTextGenerationRepo(messages);
    if (generatedText.length > 0) {
      messages.add(ChatMessageModel(
          role: 'model', parts: [ChatPartModel(text: generatedText)]));
      emit(ChatSuccessState(messages: messages));
    }
    generating = false;
  }
}