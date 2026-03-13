import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:langkara/models/inspirasi_model.dart';
import 'package:langkara/models/berita_model.dart';

class SearchService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Search profiles (Teman)
  Future<List<Map<String, dynamic>>> searchTeman(String query) async {
    final response = await _client
        .from('profiles')
        .select('id, username, avatar_url, jurusan, universitas, gender')
        .ilike('username', '%$query%')
        .limit(20);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Search materi
  Future<List<MateriFeedModel>> searchMateri(String query) async {
    final response = await _client
        .from('materi')
        .select('''
          id,
          judul,
          jurusan,
          universitas,
          cover_url,
          sumber_referensi,
          profiles!materi_author_id_fkey(
            username,
            avatar_url,
            jurusan,
            universitas
          )
        ''')
        .ilike('judul', '%$query%')
        .order('created_at', ascending: false)
        .limit(20);

    return (response as List)
        .map((e) => MateriFeedModel.fromJson(e))
        .toList();
  }

  /// Search berita
  Future<List<BeritaModel>> searchBerita(String query) async {
    final response = await _client
        .from('berita')
        .select()
        .ilike('judul', '%$query%')
        .order('date', ascending: false)
        .limit(20);

    return (response as List)
        .map((e) => BeritaModel.fromJson(e))
        .toList();
  }

  /// Search inspirasi
  Future<List<InspirasiModel>> searchInspirasi(String query) async {
    final response = await _client
        .from('inspirasi')
        .select()
        .ilike('nama', '%$query%')
        .order('created_at', ascending: false)
        .limit(20);

    return (response as List)
        .map((e) => InspirasiModel.fromJson(e))
        .toList();
  }

  /// Load all (no search query)
  Future<List<Map<String, dynamic>>> getAllTeman() async {
    final response = await _client
        .from('profiles')
        .select('id, username, avatar_url, jurusan, universitas, gender')
        .eq('is_banned', false)
        .limit(30);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<MateriFeedModel>> getAllMateri() async {
    final response = await _client
        .from('materi')
        .select('''
          id,
          judul,
          jurusan,
          universitas,
          cover_url,
          sumber_referensi,
          profiles!materi_author_id_fkey(
            username,
            avatar_url,
            jurusan,
            universitas
          )
        ''')
        .order('created_at', ascending: false)
        .limit(30);

    return (response as List)
        .map((e) => MateriFeedModel.fromJson(e))
        .toList();
  }

  Future<List<BeritaModel>> getAllBerita() async {
    final response = await _client
        .from('berita')
        .select()
        .order('date', ascending: false)
        .limit(30);

    return (response as List)
        .map((e) => BeritaModel.fromJson(e))
        .toList();
  }

  Future<List<InspirasiModel>> getAllInspirasi() async {
    final response = await _client
        .from('inspirasi')
        .select()
        .order('created_at', ascending: false)
        .limit(30);

    return (response as List)
        .map((e) => InspirasiModel.fromJson(e))
        .toList();
  }
}

