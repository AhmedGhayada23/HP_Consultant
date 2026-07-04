// domain/usecases/get_notifications_usecase.dart

import 'package:hb/core/data/models/notification_model.dart';
import 'package:hb/core/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationModel>> call() {
    return repository.getNotifications();
  }
}
