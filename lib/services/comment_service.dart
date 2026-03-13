import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/comment_model.dart';

class CommentService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _currentUserId => _client.auth.currentUser?.id;


  Future<List<CommentModel>> getMateriComments(String materiId) async {
    final response = await _client
        .from('comments')
        .select('''
          id,
          user_id,
          materi_id,
          content,
          created_at,
          profiles!comments_user_id_fkey(username, avatar_url)
        ''')
        .eq('materi_id', materiId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  Future<CommentModel> addMateriComment(
      String materiId, String content) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final result = await _client
        .from('comments')
        .insert({
          'user_id': userId,
          'materi_id': materiId,
          'content': content,
        })
        .select('''
          id,
          user_id,
          materi_id,
          content,
          created_at,
          profiles!comments_user_id_fkey(username, avatar_url)
        ''')
        .single();

    return CommentModel.fromJson(result);
  }


  Future<List<CommentModel>> getAchievementComments(
      String achievementId) async {
    final response = await _client
        .from('comments')
        .select('''
          id,
          user_id,
          achievement_id,
          content,
          created_at,
          profiles!comments_user_id_fkey(username, avatar_url)
        ''')
        .eq('achievement_id', achievementId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  Future<CommentModel> addAchievementComment(
      String achievementId, String content) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final result = await _client
        .from('comments')
        .insert({
          'user_id': userId,
          'achievement_id': achievementId,
          'content': content,
        })
        .select('''
          id,
          user_id,
          achievement_id,
          content,
          created_at,
          profiles!comments_user_id_fkey(username, avatar_url)
        ''')
        .single();

    return CommentModel.fromJson(result);
  }

  Future<int> getMateriCommentCount(String materiId) async {
    final result = await _client
        .from('comments')
        .select()
        .eq('materi_id', materiId);
    return (result as List).length;
  }

  Future<int> getAchievementCommentCount(String achievementId) async {
    final result = await _client
        .from('comments')
        .select()
        .eq('achievement_id', achievementId);
    return (result as List).length;
  }

  Future<void> deleteComment(String commentId) async {
    await _client.from('comments').delete().eq('id', commentId);
  }
}
