class ChatRoomModel {
  final String personA;
  final String personB;
  final String lastMessage;
  final int createdAt;

  ChatRoomModel({
    required this.personA,
    required this.personB,
    required this.lastMessage,
    required this.createdAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : personA = json['personA'],
        personB = json['personB'],
        lastMessage = json['lastMessage'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      "personA": personA,
      "personB": personB,
      "lastMessage": lastMessage,
      "createdAt": createdAt,
    };
  }
}
