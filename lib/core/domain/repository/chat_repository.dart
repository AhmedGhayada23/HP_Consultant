import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/datasource/chat_remote_datasource.dart';
import 'package:hb/core/data/models/chat_message_model.dart';
import 'package:hb/core/data/models/chat_model.dart';

abstract class ChatRepository {
  Future<List<ChatModel>> fetchChats({String? search, int perPage});
  Future<List<ChatMessageModel>> fetchMessages(int conversationId);
  Future<ChatMessageModel> sendMessage(int conversationId, String message,
      {List<PlatformFile> files});
  Future<ChatModel> createTicket({
    required String title,
    required String message,
    String priority,
    String? contextType,
    int? contextId,
  });
  Future<ChatModel> createDirectConversation({
    required int recipientUserId,
    String? message,
  });
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatModel>> fetchChats({String? search, int perPage = 20}) =>
      remoteDataSource.fetchChats(search: search, perPage: perPage);

  @override
  Future<List<ChatMessageModel>> fetchMessages(int conversationId) =>
      remoteDataSource.fetchMessages(conversationId);

  @override
  Future<ChatMessageModel> sendMessage(int conversationId, String message,
          {List<PlatformFile> files = const []}) =>
      remoteDataSource.sendMessage(conversationId, message, files: files);

  @override
  Future<ChatModel> createTicket({
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
  Future<ChatModel> createDirectConversation({
    required int recipientUserId,
    String? message,
  }) =>
      remoteDataSource.createDirectConversation(
        recipientUserId: recipientUserId,
        message: message,
      );
}
