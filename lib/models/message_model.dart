class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.isRead = false,
  });
}

class ChatModel {
  final String id;
  final String contactName;
  final String contactAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String companyName;

  ChatModel({
    required this.id,
    required this.contactName,
    required this.contactAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.companyName,
  });
}
