import 'package:hb/core/data/models/notification_model.dart';

class NotificationState {
  final List<NotificationModel>? notifications;
  final bool loading;
  final String? errorMessage;
  final int unreadCount;

  NotificationState({
    this.notifications,
    this.loading = false,
    this.errorMessage,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? loading,
    String? errorMessage,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
