class ConversationModel {
  final String id;
  final String user1;
  final String user2;
  final DateTime? createdAt;

  ConversationModel({
    required this.id,
    required this.user1,
    required this.user2,
    this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      user1: json['user1'] ?? '',
      user2: json['user2'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
