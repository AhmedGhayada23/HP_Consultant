class MessageConversationModel {
  final int id;
  final String? title;

  /// اسم الطرف الآخر في المحادثة (الشخص الذي راسلك)
  final String? otherParticipantName;
  final String? message;
  final String? time;
  final String? status;
  final String? priority;
  final int unreadCount;

  MessageConversationModel({
    this.id = 0,
    this.title,
    this.otherParticipantName,
    this.message,
    this.time,
    this.status,
    this.priority,
    this.unreadCount = 0,
  });

  MessageConversationModel copyWith({int? unreadCount}) {
    return MessageConversationModel(
      id: id,
      title: title,
      otherParticipantName: otherParticipantName,
      message: message,
      time: time,
      status: status,
      priority: priority,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  /// الاسم المعروض: اسم الطرف الآخر إن وُجد، وإلا عنوان المحادثة
  String get displayName {
    if (otherParticipantName != null && otherParticipantName!.trim().isNotEmpty) {
      return otherParticipantName!.trim();
    }
    return title ?? '';
  }

  factory MessageConversationModel.fromJson(Map<String, dynamic> json) {
    final lastMsg = json['last_message'];

    // اسم الطرف الآخر من other_participant ثم participants كاحتياط
    String? otherName;
    final other = json['other_participant'];
    if (other is Map && other['name'] != null) {
      otherName = other['name'].toString();
    } else if (json['participants'] is List) {
      final participants = json['participants'] as List;
      if (participants.isNotEmpty && participants.first is Map) {
        otherName = (participants.first as Map)['name']?.toString();
      }
    }

    return MessageConversationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      otherParticipantName: otherName,
      message: json['last_message_preview'] ??
          (lastMsg is Map ? (lastMsg['body'] ?? '') : ''),
      time: json['last_message_at'] ??
          (lastMsg is Map ? (lastMsg['created_at'] ?? '') : (json['created_at'] ?? '')),
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
