import 'package:hb/core/data/models/message_conversation_model.dart';

class MessageState {
  final List<MessageConversationModel>? conversationData;
  final bool isLoading;
  final String? errorMessage;

  MessageState({this.conversationData, this.isLoading = false, this.errorMessage});

  MessageState copyWith({
    List<MessageConversationModel>? conversationData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MessageState(
      conversationData: conversationData ?? this.conversationData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
