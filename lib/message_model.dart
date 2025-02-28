class MessageModel {
  String message;
  String sender; // 发送者，可以是 "user" 或 "assistant"

  MessageModel({required this.message, required this.sender});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
    };
  }
}

class SessionModel {
  String sessionId;
  List<MessageModel> messages;

  SessionModel({required this.sessionId, required this.messages});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      messages: List<MessageModel>.from(
          json['messages'].map((message) => MessageModel.fromJson(message))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
     'sessionId': sessionId,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}