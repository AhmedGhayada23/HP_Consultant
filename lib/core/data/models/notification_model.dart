class NotificationModel {
  final int id;
  final String title;
  final String subTitle;
  final bool isRead;
  final String? createdAt;

  /// نوع/غرض/إجراء الإشعار — تُستخدم للتوجيه عند الضغط
  final String? action;
  final String? type;

  /// بيانات إضافية للتوجيه (conversation_id, message_id …)
  final Map<String, dynamic>? data;

  NotificationModel({
    this.id = 0,
    required this.title,
    required this.subTitle,
    this.isRead = false,
    this.createdAt,
    this.action,
    this.type,
    this.data,
  });

  /// خريطة جاهزة لمنطق التوجيه (FbNotifications)
  Map<String, dynamic> get navigationPayload => {
        'action': action,
        'type': type,
        'title': title,
        if (data != null) 'data': data,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subTitle: json['body'] ?? json['sub_title'] ?? '',
      isRead: json['read_at'] != null || json['is_read'] == true,
      createdAt: json['created_at'],
      action: json['action']?.toString(),
      type: json['type']?.toString() ?? json['purpose']?.toString(),
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      subTitle: subTitle,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      action: action,
      type: type,
      data: data,
    );
  }
}
