import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/chat_message_model.dart';
import 'package:hb/core/data/models/chat_model.dart';

abstract class ChatRemoteDataSource {
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

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  // ── التحقق من الـ status code وإلقاء exception واضح ─────────────────────
  void _throwIfError(Response response) {
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      final msg = response.data is Map
          ? (response.data['message'] ?? 'Server error $status')
          : 'Server error $status';
      throw Exception(msg);
    }
  }

  @override
  Future<List<ChatModel>> fetchChats({String? search, int perPage = 20}) async {
    final response = await _dio.get(
      Constants.chatConversationsUrl, // GET /api/chat/conversations
      queryParameters: {
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    _throwIfError(response);
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list.map((e) => ChatModel.fromJson(e)).toList();
  }

  @override
  Future<List<ChatMessageModel>> fetchMessages(int conversationId) async {
    final response = await _dio.get(
      '${Constants.chatConversationsUrl}/$conversationId', // GET /api/chat/conversations/{id}
      queryParameters: {'per_page': 30},
    );
    _throwIfError(response);
    final data = response.data;
    if (data == null) return [];
    final detail = data['data'] ?? data;
    final List msgs = detail is Map
        ? (detail['messages'] ?? detail['data'] ?? [])
        : [];
    final list = msgs.map((e) => ChatMessageModel.fromJson(e)).toList();
    // ترتيب زمني تصاعدي (الأقدم أولاً) ليظهر الأحدث بالأسفل
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  @override
  Future<ChatMessageModel> sendMessage(int conversationId, String message,
      {List<PlatformFile> files = const []}) async {
    final url = '${Constants.chatConversationsUrl}/$conversationId/messages'; // POST /api/chat/conversations/{id}/messages
    dynamic body;
    if (files.isNotEmpty) {
      // إرسال مرفق واحد (صورة/ملف) كـ multipart تحت اسم الحقل "attachment"
      final formData = FormData.fromMap({
        if (message.trim().isNotEmpty) 'message': message,
      });
      final f = files.first;
      if (f.path != null) {
        formData.files.add(MapEntry(
          'attachment',
          await MultipartFile.fromFile(f.path!, filename: f.name),
        ));
      } else if (f.bytes != null) {
        formData.files.add(MapEntry(
          'attachment',
          MultipartFile.fromBytes(f.bytes!, filename: f.name),
        ));
      }
      body = formData;
    } else {
      body = {'message': message};
    }

    final response = await _dio.post(url, data: body);
    _throwIfError(response);
    final data = response.data;
    final msgJson = data is Map ? (data['data'] ?? data) : {};
    return ChatMessageModel.fromJson(Map<String, dynamic>.from(msgJson as Map));
  }

  @override
  Future<ChatModel> createTicket({
    required String title,
    required String message,
    String priority = 'normal',
    String? contextType,
    int? contextId,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'message': message,
      'priority': priority,
    };
    if (contextType != null) body['context_type'] = contextType;
    if (contextId != null) body['context_id'] = contextId;

    final response = await _dio.post(
      Constants.chatConversationsUrl,
      data: body,
    );
    _throwIfError(response);
    final data = response.data;
    return ChatModel.fromJson(data['data'] ?? data ?? {});
  }

  @override
  Future<ChatModel> createDirectConversation({
    required int recipientUserId,
    String? message,
  }) async {
    final response = await _dio.post(
      Constants.chatDirectConversationsUrl,
      data: {
        'recipient_user_id': recipientUserId,
        if (message != null && message.isNotEmpty) 'message': message,
      },
    );
    _throwIfError(response);
    final data = response.data;
    return ChatModel.fromJson(data['data'] ?? data ?? {});
  }
}
