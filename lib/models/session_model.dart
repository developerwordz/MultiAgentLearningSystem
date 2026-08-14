class Session {
  final int id;
  final String userId;
  final String topic;
  final DateTime createdAt;
  final DateTime updatedAt;

  Session({
    required this.id,
    required this.userId,
    required this.topic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      topic: map['topic'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'topic': topic,
    };
  }
}