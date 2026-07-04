import 'package:hb/core/data/models/message_item_model.dart';

class MessageConversationState {
  final List<MessageItemModel> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;
  final String conversationTitle;

  MessageConversationState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
    this.conversationTitle = '',
  });

  MessageConversationState copyWith({
    List<MessageItemModel>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    String? conversationTitle,
  }) {
    return MessageConversationState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
      conversationTitle: conversationTitle ?? this.conversationTitle,
    );
  }
}
