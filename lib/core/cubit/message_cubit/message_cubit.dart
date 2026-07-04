import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/message_cubit/message_state.dart';
import 'package:hb/core/helper/pusher_service.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageState());

  int? _userId;
  String? _channel;
  String? _lastSearch;
  bool _refreshing = false;
  bool _pendingRefresh = false;

  void fetchConversations({String? search}) async {
    _lastSearch = search;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final fetchedData =
          await UseCases.getMessageRepositoryUsecase(search: search);
      emit(state.copyWith(conversationData: fetchedData, isLoading: false));
      await _connectRealtime();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ── الاشتراك بقناة المستخدم لتحديثات القائمة لحظياً ───────────────────────
  Future<void> _connectRealtime() async {
    if (_channel != null) return; // مشترك أصلاً
    final userId = await _resolveUserId();
    if (userId == null) return;
    _channel = '${Constants.pusherChannelUser}$userId';
    await PusherService.instance.subscribe(channelName: _channel!, onEvent: _onEvent);
  }

  // معرّف المستخدم: من التخزين، وإلا نجلب البروفايل لمعرفته
  Future<int?> _resolveUserId() async {
    if (_userId != null) return _userId;
    final stored = LocalStorage().readValue<int>(Constants.userId);
    if (stored != null && stored != 0) return _userId = stored;
    try {
      final profile = await UseCases.getProfileUsecase.get();
      if (profile.user.id != 0) {
        _userId = profile.user.id;
        LocalStorage().writeValue(Constants.userId, _userId);
      }
    } catch (e) {
      log('Message list: resolve userId failed: $e');
    }
    return _userId;
  }

  // تصفير عدّاد محادثة فوراً عند فتحها (تفاؤلياً قبل ردّ السيرفر)
  void markConversationRead(int conversationId) {
    final current = state.conversationData;
    if (current == null) return;
    final list = current
        .map((c) => c.id == conversationId && c.unreadCount > 0
            ? c.copyWith(unreadCount: 0)
            : c)
        .toList();
    emit(state.copyWith(conversationData: list));
  }

  // مزامنة القائمة مع السيرفر (تُستدعى بعد الرجوع من محادثة)
  Future<void> syncList() => _refreshSilently();

  // ── عند أي تحديث محادثة، نعيد الجلب من السيرفر للحصول على عدّاد غير المقروء الصحيح ──
  // (unread_count القادم من البثّ غير موثوق لكل مستلم، فلا نعتمد عليه)
  void _onEvent(PusherEvent event) {
    if (event.eventName != Constants.pusherEventConversation) return;
    _refreshSilently();
  }

  // إعادة جلب بدون إظهار سكيليتون، مع منع التداخل وتجميع الأحداث المتتابعة
  Future<void> _refreshSilently() async {
    if (_refreshing) {
      _pendingRefresh = true;
      return;
    }
    _refreshing = true;
    try {
      final data = await UseCases.getMessageRepositoryUsecase(search: _lastSearch);
      emit(state.copyWith(conversationData: data));
    } catch (e) {
      log('Message list silent refresh failed: $e');
    } finally {
      _refreshing = false;
      if (_pendingRefresh) {
        _pendingRefresh = false;
        _refreshSilently();
      }
    }
  }

  @override
  Future<void> close() async {
    if (_channel != null) {
      await PusherService.instance.unsubscribe(_channel!);
    }
    return super.close();
  }
}
