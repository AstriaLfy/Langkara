import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/materi_model.dart';

class MateriService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MateriFeedModel>> getMateriFeed() async {
    final response = await _client
        .from('materi')
        .select('''
          id,
          judul,
          jurusan,
          universitas,
          cover_url,
          profiles!materi_author_id_fkey(
            username,
            avatar_url
          )
        ''')
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => MateriFeedModel.fromJson(e))
        .toList();
  }


  Future<void> materiUpload({
    required String judul,
    required String kategori,
    required List<String> imagePaths,
    required String deskripsi,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception("User tidak terautentikasi brok!");

      final profileData = await _client
          .from('profiles')
          .select('jurusan, universitas, username')
          .eq('id', user.id)
          .single();

      List<String> uploadedUrls = [];
      for (String path in imagePaths) {
        final file = File(path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final pathInStorage = 'materi/${user.id}/$fileName';

        await _client.storage.from('materi_bucket').upload(pathInStorage, file);

        final url = _client.storage.from('materi_bucket').getPublicUrl(pathInStorage);
        uploadedUrls.add(url);
      }

      await _client.from('materi').insert({
        'author_id': user.id,
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori': kategori,
        'jurusan': profileData['jurusan'],
        'universitas': profileData['universitas'],
        'cover_url': uploadedUrls.first,
        'all_images': uploadedUrls,
        'jumlah_slide': uploadedUrls.length,
        'is_valid': false,
        'xp_reward': 100,
        'created_at': DateTime.now().toIso8601String(),
      });

      print("Upload Berhasil!");

    } catch (e) {
      print("Error detail: $e");
      throw Exception('Gagal upload: $e');
    }
  }

}