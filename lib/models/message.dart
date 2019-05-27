/*class Message {
  String id, priority, title, teaser;
  int created;
  bool isRead;

  Message({
    this.id,
    this.priority,
    this.title,
    this.teaser,
    this.created,
    this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    return Message(
      id: parsedJson['id'],
      priority: parsedJson['priority'],
      title: parsedJson['title'],
      teaser: parsedJson['teaser'],
      created: parsedJson['created'],
      isRead: parsedJson['read'],
    );
  }
}

class MessagesList {
  List<Message> oldMessages, newMessages;

  MessagesList({
    this.oldMessages,
    this.newMessages,
  });

  factory MessagesList.fromJson(Map<String, dynamic> parsedJson) {
    var oldMessagesList = parsedJson['old'] as List;
    List<Message> oldMessages =
        oldMessagesList.map((i) => Message.fromJson(i)).toList();

    var newMessagesList = parsedJson['new'] as List;
    List<Message> newMessages =
        newMessagesList.map((i) => Message.fromJson(i)).toList();

    return MessagesList(
      oldMessages: oldMessages,
      newMessages: newMessages,
    );
  }
}
*/