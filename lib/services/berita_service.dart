import 'package:supabase_flutter/supabase_flutter.dart';

class BeritaService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<dynamic>> getBerita() async {
    final data = await _client
        .from('berita')
        .select()
        .order('date', ascending: false)
        .limit(2);
    return data;
  }
}