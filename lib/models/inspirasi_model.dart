class InspirasiModel {
  final int inspirasiId;
  final String nama;
  final String profesi;
  final String? deskripsi;
  final String? photoUrl;
  final DateTime? createdAt;

  InspirasiModel({
    required this.inspirasiId,
    required this.nama,
    required this.profesi,
    this.deskripsi,
    this.photoUrl,
    this.createdAt,
  });

  factory InspirasiModel.fromJson(Map<String, dynamic> json) {
    return InspirasiModel(
      inspirasiId: json['inspirasi_id'] ?? 0,
      nama: json['nama'] ?? '',
      profesi: json['profesi'] ?? '',
      deskripsi: json['deskripsi'],
      photoUrl: json['photo_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
