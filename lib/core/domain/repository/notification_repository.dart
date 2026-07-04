import 'package:hb/core/data/datasource/notification_remote_datasource.dart';
import 'package:hb/core/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationModel>> getNotifications() {
    return remoteDataSource.fetchNotifications();
  }

  @override
  Future<void> markAsRead(int id) {
    return remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() {
    return remoteDataSource.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() {
    return remoteDataSource.fetchUnreadCount();
  }
}
