import 'package:supabase_flutter/supabase_flutter.dart';

class ReadingService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getLastRead() async {
    final user = _client.auth.currentUser;
    print("DEBUG USER ID: ${user?.id}");
    if (user == null) return [];

    final data = await _client
    
        .from('user_materi_progress')
        .select('''
          *,
          materi (*)
        ''')
        .eq('user_id', user.id)
        .order('last_read_at', ascending: false)
        .limit(2);

print("DEBUG SUPABASE DATA: $data");

    return List<Map<String, dynamic>>.from(data);
  }
} 