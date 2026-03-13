class BeritaModel {
  final int id;
  final String judul;
  final String? deskripsi;
  final String? sumber;
  final String? photoUrl;
  final DateTime? date;
  final DateTime? uploadedAt;

  BeritaModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    this.sumber,
    this.photoUrl,
    this.date,
    this.uploadedAt,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      sumber: json['sumber'],
      photoUrl: json['photo_url'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'])
          : null,
    );
  }

  /// Format tanggal ke bahasa Indonesia, e.g. "Jumat, 6 Maret 2026"
  String get formattedDate {
    if (date == null) return '-';
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    final d = date!;
    final dayName = days[d.weekday - 1];
    return '$dayName, ${d.day} ${months[d.month]} ${d.year}';
  }

  /// "Diunggah pada X hari yang lalu"
  String get uploadedAgo {
    if (uploadedAt == null) return '';
    final diff = DateTime.now().difference(uploadedAt!);
    if (diff.inDays == 0) return 'Diunggah hari ini';
    if (diff.inDays == 1) return 'Diunggah kemarin';
    return 'Diunggah pada ${diff.inDays} hari yang lalu';
  }
}
