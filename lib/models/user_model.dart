class UserModel {
  final String id;
  final String username;
  final String email;
  final String? jurusan;
  final String? universitas;
  final int totalXp;
  final int tiketBacaSisa;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.jurusan,
    this.universitas,
    required this.totalXp,
    required this.tiketBacaSisa,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      jurusan: json['jurusan'] as String?,
      universitas: json['universitas'] as String?,
      totalXp: json['total_xp'] ?? 0,
      tiketBacaSisa: json['tiket_baca_sisa'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'jurusan': jurusan,
      'universitas': universitas,
      'total_xp': totalXp,
      'tiket_baca_sisa': tiketBacaSisa,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? jurusan,
    String? universitas,
    int? totalXp,
    int? tiketBacaSisa,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      jurusan: jurusan ?? this.jurusan,
      universitas: universitas ?? this.universitas,
      totalXp: totalXp ?? this.totalXp,
      tiketBacaSisa: tiketBacaSisa ?? this.tiketBacaSisa,
      createdAt: createdAt,
    );
  }
}