class AchievementModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? category;
  final String? certificateImageUrl;
  final DateTime? achievedAt;
  final DateTime? createdAt;

  AchievementModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.category,
    this.certificateImageUrl,
    this.achievedAt,
    this.createdAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      category: json['category'],
      certificateImageUrl: json['certificate_image_url'],
      achievedAt: json['achieved_at'] != null
          ? DateTime.tryParse(json['achieved_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
