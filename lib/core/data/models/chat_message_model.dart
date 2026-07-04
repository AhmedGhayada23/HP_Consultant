class ChatMessageModel {
  final int id;
  final String body;
  final bool isMine;
  final int? senderId;
  final String? senderName;
  final String? createdAt;
  final String type;
  final List<ChatAttachmentModel> attachments;

  ChatMessageModel({
    this.id = 0,
    required this.body,
    this.isMine = false,
    this.senderId,
    this.senderName,
    this.createdAt,
    this.type = 'text',
    this.attachments = const [],
  });

  bool get isFromUser => isMine;
  bool get hasText => body.trim().isNotEmpty;
  bool get hasAttachments => attachments.isNotEmpty;

  ChatMessageModel copyWith({bool? isMine}) {
    return ChatMessageModel(
      id: id,
      body: body,
      isMine: isMine ?? this.isMine,
      senderId: senderId,
      senderName: senderName,
      createdAt: createdAt,
      type: type,
      attachments: attachments,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] is Map
        ? Map<String, dynamic>.from(json['sender'])
        : null;
    final senderId = sender?['id'] is int
        ? sender!['id'] as int
        : int.tryParse('${sender?['id']}');

    final rawAttachments = json['attachments'];
    final attachments = rawAttachments is List
        ? rawAttachments
            .whereType<Map>()
            .map((e) => ChatAttachmentModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <ChatAttachmentModel>[];

    return ChatMessageModel(
      id: json['id'] ?? 0,
      body: json['body'] ?? json['message'] ?? '',
      isMine: json['is_mine'] ?? false,
      senderId: senderId,
      senderName: sender?['name'] as String?,
      createdAt: json['created_at'],
      type: json['type']?.toString() ?? 'text',
      attachments: attachments,
    );
  }
}

class ChatAttachmentModel {
  final String name;
  final String url;
  final String? displayUrl;
  final String? fileType;
  final int? fileSize;
  final String? createdAt;

  ChatAttachmentModel({
    this.name = '',
    this.url = '',
    this.displayUrl,
    this.fileType,
    this.fileSize,
    this.createdAt,
  });

  // هل المرفق صورة (حسب نوع الملف)
  bool get isImage => (fileType ?? '').toLowerCase().startsWith('image/');

  // الرابط المناسب للعرض/المعاينة
  String get previewUrl =>
      (displayUrl != null && displayUrl!.isNotEmpty) ? displayUrl! : url;

  // حجم الملف بصيغة مقروءة
  String get sizeDisplay {
    final size = fileSize;
    if (size == null || size <= 0) return '';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentModel(
      name: (json['name'] ?? json['file_name'] ?? json['filename'] ?? '').toString(),
      url: (json['url'] ?? json['file_url'] ?? json['path'] ?? '').toString(),
      displayUrl:
          (json['display_url'] ?? json['image_url'])?.toString(),
      fileType: json['file_type']?.toString(),
      fileSize: json['file_size'] is int
          ? json['file_size'] as int
          : int.tryParse('${json['file_size']}'),
      createdAt: json['created_at']?.toString(),
    );
  }
}
