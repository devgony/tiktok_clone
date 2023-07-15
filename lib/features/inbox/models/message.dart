class MessageModel {
  final String text;
  final String userId;
  final int createdAt;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        userId = json['userId'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
    };
  }
}
