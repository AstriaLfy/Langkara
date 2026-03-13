import 'package:langkara/models/achievement_model.dart';

class TemanProfileModel {
  final String id;
  final String username;
  final String? nama;
  final String? jurusan;
  final String? universitas;
  final String? avatarUrl;
  final String? gender;
  final String? kemampuan;
  final int totalXp;
  final int tiketBacaSisa;
  final bool isBanned;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final List<AchievementModel> achievements;

  TemanProfileModel({
    required this.id,
    required this.username,
    this.nama,
    this.jurusan,
    this.universitas,
    this.avatarUrl,
    this.gender,
    this.kemampuan,
    required this.totalXp,
    required this.tiketBacaSisa,
    required this.isBanned,
    this.createdAt,
    this.lastLogin,
    required this.achievements,
  });

  /// Pencapaian = semua achievement titles
  List<String> get pencapaian =>
      achievements.map((a) => a.title).toList();

  factory TemanProfileModel.fromJson(Map<String, dynamic> json) {
    final achievementList = (json['achievements'] as List<dynamic>?)
            ?.map((a) =>
                AchievementModel.fromJson(a as Map<String, dynamic>))
            .toList() ??
        [];

    return TemanProfileModel(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Anonim',
      nama: json['nama'],
      jurusan: json['jurusan'],
      universitas: json['universitas'],
      avatarUrl: json['avatar_url'],
      gender: json['gender'],
      kemampuan: json['kemampuan'],
      totalXp: json['total_xp'] ?? 0,
      tiketBacaSisa: json['tiket_baca_sisa'] ?? 0,
      isBanned: json['is_banned'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      lastLogin: json['last_login'] != null
          ? DateTime.tryParse(json['last_login'])
          : null,
      achievements: achievementList,
    );
  }
}
