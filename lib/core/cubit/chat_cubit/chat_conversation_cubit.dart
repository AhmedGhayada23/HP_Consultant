import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_state.dart';
import 'package:hb/core/data/models/chat_message_model.dart';
import 'package:hb/core/helper/pusher_service.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final int conversationId;
  final String title;

  String get _channel => '${Constants.pusherChannelConversation}$conversationId';

  /// معرّف المستخدم الحالي — نتعلّمه من رسائل REST (is_mine موثوق فيها)
  /// لأن is_mine القادم من Pusher غير موثوق (البث لا يحسبه لكل مستمع)
  int? _currentUserId;

  ChatConversationCubit({required this.conversationId, required this.title})
      : super(ChatConversationState(conversationTitle: title));

  // ── جلب الرسائل + تشغيل Pusher ──────────────────────────────────────────
  Future<void> fetchMessages() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final messages =
          await UseCases.chatRepository.fetchMessages(conversationId);
      // استنتاج معرّف المستخدم الحالي من أول رسالة is_mine == true
      _currentUserId ??= messages
          .where((m) => m.isMine && m.senderId != null)
          .map((m) => m.senderId)
          .cast<int?>()
          .firstWhere((id) => id != null, orElse: () => null);
      emit(state.copyWith(messages: messages, isLoading: false));
      await PusherService.instance.subscribe(channelName: _channel, onEvent: _onEvent);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ── استقبال الرسائل real-time ────────────────────────────────────────────
  void _onEvent(PusherEvent event) {
    if (event.eventName != Constants.pusherEventMessage) return;
    try {
      final raw = jsonDecode(event.data ?? '{}');
      // الباك اند قد يرسل { message: {...} } أو مباشرة { id, body, ... }
      final msgJson = raw is Map && raw.containsKey('message')
          ? raw['message'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;

      var newMsg = ChatMessageModel.fromJson(msgJson);

      // is_mine من Pusher غير موثوق → احسبه من معرّف المُرسِل إن أمكن
      if (_currentUserId != null && newMsg.senderId != null) {
        newMsg = newMsg.copyWith(isMine: newMsg.senderId == _currentUserId);
      }

      // تجنب التكرار لو نفس الـ id موجود
      final exists = state.messages.any((m) => m.id == newMsg.id);
      if (!exists) {
        emit(state.copyWith(messages: [...state.messages, newMsg]));
      }
    } catch (e) {
      log('Pusher event parse error: $e');
    }
  }

  // ── إرسال رسالة ──────────────────────────────────────────────────────────
  Future<void> sendMessage(String message,
      {List<PlatformFile> files = const []}) async {
    if (message.trim().isEmpty && files.isEmpty) return;
    emit(state.copyWith(isSending: true));
    try {
      final sent = await UseCases.chatRepository
          .sendMessage(conversationId, message.trim(), files: files);
      // تعلّم معرّف المستخدم الحالي من رسالتي المُرسَلة (is_mine == true)
      _currentUserId ??= sent.senderId;

      // ردّ POST موثوق → استبدل أي نسخة وصلت من Pusher (قد تكون is_mine خاطئة)
      final updated = [...state.messages];
      final idx = sent.id != 0
          ? updated.indexWhere((m) => m.id == sent.id)
          : -1;
      if (idx >= 0) {
        updated[idx] = sent;
      } else {
        updated.add(sent);
      }
      emit(state.copyWith(isSending: false, messages: updated));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  // ── إلغاء الاشتراك عند الخروج ────────────────────────────────────────────
  @override
  Future<void> close() async {
    await PusherService.instance.unsubscribe(_channel);
    return super.close();
  }
}
