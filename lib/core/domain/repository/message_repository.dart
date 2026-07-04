import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/datasource/message_remote_datasource.dart';
import 'package:hb/core/data/models/message_item_model.dart';
import 'package:hb/core/data/models/message_conversation_model.dart';

abstract class MessageRepository {
  Future<List<MessageConversationModel>> fetchConversations({String? search, int perPage});
  Future<List<MessageItemModel>> fetchMessages(int conversationId);
  Future<MessageItemModel> sendMessage(int conversationId, String message,
      {List<PlatformFile> files});
  Future<MessageConversationModel> createTicket({
    required String title,
    required String message,
    String priority,
    String? contextType,
    int? contextId,
  });
  Future<MessageConversationModel> createDirectConversation({
    required int recipientUserId,
    String? message,
  });
}

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MessageConversationModel>> fetchConversations(
          {String? search, int perPage = 20}) =>
      remoteDataSource.fetchConversations(search: search, perPage: perPage);

  @override
  Future<List<MessageItemModel>> fetchMessages(int conversationId) =>
      remoteDataSource.fetchMessages(conversationId);

  @override
  Future<MessageItemModel> sendMessage(int conversationId, String message,
          {List<PlatformFile> files = const []}) =>
      remoteDataSource.sendMessage(conversationId, message, files: files);

  @override
  Future<MessageConversationModel> createTicket({
    required String title,
    required String message,
    String priority = 'normal',
    String? contextType,
    int? contextId,
  }) =>
      remoteDataSource.createTicket(
        title: title,
        message: message,
        priority: priority,
        contextType: contextType,
        contextId: contextId,
      );

  @override
  Future<MessageConversationModel> createDirectConversation({
    required int recipientUserId,
    String? message,
  }) =>
      remoteDataSource.createDirectConversation(
        recipientUserId: recipientUserId,
        message: message,
      );
}
