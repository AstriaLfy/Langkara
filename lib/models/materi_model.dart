class MateriFeedModel {
  final String id;
  final String? authorId;
  final String judul;
  final String? kategori;
  final String? jurusan;
  final String? universitas;
  final String? coverUrl;
  final int? jumlahSlide;
  final String? sumberReferensi;
  final int? xpReward;
  final bool? isValid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? allImages;
  final String? deskripsi;

  final String authorName;
  final String? authorAvatar;
  final String? authorJurusan;
  final String? authorUniversitas;

  MateriFeedModel({
    required this.id,
    this.authorId,
    required this.judul,
    this.kategori,
    this.jurusan,
    this.universitas,
    this.coverUrl,
    this.jumlahSlide,
    this.sumberReferensi,
    this.xpReward,
    this.isValid,
    this.createdAt,
    this.updatedAt,
    this.allImages,
    this.deskripsi,
    required this.authorName,
    this.authorAvatar,
    this.authorJurusan,
    this.authorUniversitas,
  });

  factory MateriFeedModel.fromJson(Map<String, dynamic> json) {
    final author = json['profiles'] ?? {};

    return MateriFeedModel(
      id: json['id'] ?? '',
      authorId: json['author_id'],
      judul: json['judul'] ?? 'Tanpa Judul',
      kategori: json['kategori'],
      jurusan: json['jurusan'],
      universitas: json['universitas'],
      coverUrl: json['cover_url'],
      jumlahSlide: json['jumlah_slide'],
      sumberReferensi: json['sumber_referensi'],
      xpReward: json['xp_reward'],
      isValid: json['is_valid'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      allImages: json['all_images'],
      deskripsi: json['deskripsi'],
      authorName: author['username'] ?? 'Anonim',
      authorAvatar: author['avatar_url'],
      authorJurusan: author['jurusan'],
      authorUniversitas: author['universitas'],
    );
  }
}