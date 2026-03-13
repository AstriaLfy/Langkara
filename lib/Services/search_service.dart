import 'package:supabase_flutter/supabase_flutter.dart';

class SearchService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) return [];

    final data = await _client
        .from('user_search_history')
        .select('''
          *,
          target_user:profiles(*)
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(data);
  }
}