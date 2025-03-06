class MessageModel {
  String reasoningContent;
  String content;
  String sender; // 发送者，可以是 "user" 或 "assistant"

  MessageModel({required this.content, required this.reasoningContent, required this.sender});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      reasoningContent: json['reasoningContent'],
      content: json['content'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reasoningContent': reasoningContent,
      'content': content,
      'sender': sender,
    };
  }
}

class SessionModel {
  int sessionId;
  String title;
  int modifyTimestamp;

  SessionModel({required this.sessionId, required this.title, required this.modifyTimestamp});

  factory SessionModel.fromJson(Map<dynamic, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      title: json['title'],
      modifyTimestamp: json['modifyTimestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
     'sessionId': sessionId,
      'title': title,
      'modifyTimestamp': modifyTimestamp,
    };
  }
}