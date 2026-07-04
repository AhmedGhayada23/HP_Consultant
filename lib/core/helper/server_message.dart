class ServerMessage {
  final String rawMessage;
  final List<String> messages;

  ServerMessage._({required this.rawMessage, required this.messages});

  factory ServerMessage.fromResponse(dynamic message) {
    if (message == null) return ServerMessage._(rawMessage: '', messages: []);
    if (message is String) return ServerMessage._(rawMessage: message, messages: [message]);
    if (message is Map) {
      List<String> collected = [];
      message.forEach((key, value) {
        if (value is List) {
          collected.addAll(value.map((e) => e.toString()));
        } else {
          collected.add(value.toString());
        }
      });
      return ServerMessage._(rawMessage: collected.join('\n'), messages: collected);
    }
    return ServerMessage._(rawMessage: message.toString(), messages: [message.toString()]);
  }

  String get asBullets => messages.map((m) => '• $m').join('\n');

  // ✅ إضافة دالة contains
  bool contains(String text) {
    return messages.any((m) => m.contains(text)) || rawMessage.contains(text);
  }
}
