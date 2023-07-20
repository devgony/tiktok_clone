class ChatRoomModel {
  final String personA;
  final String personB;
  final String lastMessage;
  final int updatedAt;

  ChatRoomModel({
    required this.personA,
    required this.personB,
    required this.lastMessage,
    required this.updatedAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : personA = json['personA'],
        personB = json['personB'],
        lastMessage = json['lastMessage'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      "personA": personA,
      "personB": personB,
      "lastMessage": lastMessage,
      "updatedAt": updatedAt,
    };
  }
}
