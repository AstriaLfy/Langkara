class MateriFeedModel {
  final String id;
  final String judul;
  final String? jurusan;
  final String? universitas;
  final String? coverUrl;

  final String authorName;
  final String? authorAvatar;

  MateriFeedModel({
    required this.id,
    required this.judul,
    this.jurusan,
    this.universitas,
    this.coverUrl,
    required this.authorName,
    this.authorAvatar,
  });

  factory MateriFeedModel.fromJson(Map<String, dynamic> json) {
    final author = json['profiles'];

    return MateriFeedModel(
      id: json['id'],
      judul: json['judul'],
      jurusan: json['jurusan'],
      universitas: json['universitas'],
      coverUrl: json['cover_url'],
      authorName: author['username'],
      authorAvatar: author['avatar_url'],
    );
  }
}