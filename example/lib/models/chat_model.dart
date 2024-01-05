class ChatModel {
  int? id;
  final String name;
  final String message;
  final DateTime created;
  final bool incoming;
  bool isSending;
  bool isSent;

  ChatModel({
    this.id,
    required this.name,
    required this.message,
    required this.incoming,
    required this.created,
    this.isSending = false,
    this.isSent = false,
  });

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatModel(
      name: json['name'],
      message: json['message'],
      created: json['time'],
      incoming: json['incoming'],
    );
  }
}
