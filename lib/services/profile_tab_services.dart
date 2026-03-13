import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTabService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// MATERI USER
  Future<List<Map<String, dynamic>>> getUserMateri() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('materi')
        .select()
        .eq('author_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// ACHIEVEMENT USER
  Future<List<Map<String, dynamic>>> getUserAchievements() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('achievements')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// BOOKMARK USER
  Future<List<Map<String, dynamic>>> getUserBookmarks() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('bookmarks')
        .select('*, materi(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}