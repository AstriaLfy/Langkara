class CommentModel {
  final String id;
  final String userId;
  final String? materiId;
  final String? achievementId;
  final String content;
  final DateTime? createdAt;

  // Joined profile data
  final String? username;
  final String? avatarUrl;

  CommentModel({
    required this.id,
    required this.userId,
    this.materiId,
    this.achievementId,
    required this.content,
    this.createdAt,
    this.username,
    this.avatarUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'];
    return CommentModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      materiId: json['materi_id'],
      achievementId: json['achievement_id'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      username: profile != null ? profile['username'] : null,
      avatarUrl: profile != null ? profile['avatar_url'] : null,
    );
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}th lalu';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}bln lalu';
    if (diff.inDays > 0) return '${diff.inDays}h lalu';
    if (diff.inHours > 0) return '${diff.inHours}jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes}mnt lalu';
    return 'Baru saja';
  }
}
