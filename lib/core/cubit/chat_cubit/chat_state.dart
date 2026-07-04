import 'package:hb/core/data/models/chat_model.dart';

class ChatState {
  final List<ChatModel>? chatData;
  final bool isLoading;
  final String? errorMessage;

  ChatState({this.chatData, this.isLoading = false, this.errorMessage});

  ChatState copyWith({List<ChatModel>? chatData, bool? isLoading, String? errorMessage}) {
    return ChatState(
      chatData: chatData ?? this.chatData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
