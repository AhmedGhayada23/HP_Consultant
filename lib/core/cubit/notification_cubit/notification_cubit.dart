import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/notification_cubit/notification_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  Future<void> fetchNotifications() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final notifications = await UseCases.getNotificationsUseCase();
      final unread = notifications.where((n) => !n.isRead).length;
      emit(state.copyWith(
        notifications: notifications,
        loading: false,
        unreadCount: unread,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await UseCases.notificationRepository.markAsRead(id);
      final updated = state.notifications?.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();
      final unread = updated?.where((n) => !n.isRead).length ?? 0;
      emit(state.copyWith(notifications: updated, unreadCount: unread));
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await UseCases.notificationRepository.markAllAsRead();
      final updated = state.notifications
          ?.map((n) => n.copyWith(isRead: true))
          .toList();
      emit(state.copyWith(notifications: updated, unreadCount: 0));
    } catch (_) {}
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await UseCases.notificationRepository.getUnreadCount();
      emit(state.copyWith(unreadCount: count));
    } catch (_) {}
  }
}
