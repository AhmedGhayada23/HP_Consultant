import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<int> fetchUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _dio.get(Constants.notificationsUrl);
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await _dio.post('${Constants.notificationsUrl}/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _dio.post(Constants.notificationsReadAllUrl);
  }

  @override
  Future<int> fetchUnreadCount() async {
    final response = await _dio.get(Constants.notificationsUnreadCountUrl);
    return _extractCount(response.data);
  }

  // يستخرج العدد سواء كان بالأعلى أو داخل data المتداخل، وبأي نوع (int/num/String)
  int _extractCount(dynamic data) {
    if (data is num) return data.toInt();
    if (data is String) return int.tryParse(data) ?? 0;
    if (data is Map) {
      for (final key in ['count', 'unread_count', 'unread', 'unreadCount']) {
        final v = data[key];
        if (v is num) return v.toInt();
        if (v is String) {
          final parsed = int.tryParse(v);
          if (parsed != null) return parsed;
        }
      }
      if (data['data'] != null) return _extractCount(data['data']);
    }
    return 0;
  }
}
