import 'package:hb/core/data/models/chat_message_model.dart';

class ChatConversationState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;
  final String conversationTitle;

  ChatConversationState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
    this.conversationTitle = '',
  });

  ChatConversationState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    String? conversationTitle,
  }) {
    return ChatConversationState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
      conversationTitle: conversationTitle ?? this.conversationTitle,
    );
  }
}
