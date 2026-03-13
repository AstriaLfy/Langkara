import 'package:supabase_flutter/supabase_flutter.dart';

class InteractionService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _currentUserId => _client.auth.currentUser?.id;


  Future<bool> isLiked(String materiId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final result = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('materi_id', materiId)
        .maybeSingle();

    return result != null;
  }

  Future<bool> toggleLike(String materiId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final existing = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('materi_id', materiId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('materi_id', materiId);
      return false;
    } else {
      await _client.from('likes').insert({
        'user_id': userId,
        'materi_id': materiId,
      });
      return true;
    }
  }

  Future<int> getLikeCount(String materiId) async {
    final result = await _client
        .from('likes')
        .select()
        .eq('materi_id', materiId);

    return (result as List).length;
  }


  Future<bool> isBookmarked(String materiId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final result = await _client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('materi_id', materiId)
        .maybeSingle();

    return result != null;
  }

  Future<bool> toggleBookmark(String materiId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final existing = await _client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('materi_id', materiId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('materi_id', materiId);
      return false;
    } else {
      await _client.from('bookmarks').insert({
        'user_id': userId,
        'materi_id': materiId,
      });
      return true;
    }
  }


  Future<bool> isAchievementLiked(String achievementId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final result = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('achievement_id', achievementId)
        .maybeSingle();

    return result != null;
  }

  Future<bool> toggleAchievementLike(String achievementId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final existing = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('achievement_id', achievementId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('achievement_id', achievementId);
      return false;
    } else {
      await _client.from('likes').insert({
        'user_id': userId,
        'achievement_id': achievementId,
      });
      return true;
    }
  }

  Future<int> getAchievementLikeCount(String achievementId) async {
    final result = await _client
        .from('likes')
        .select()
        .eq('achievement_id', achievementId);

    return (result as List).length;
  }


  Future<bool> isAchievementBookmarked(String achievementId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final result = await _client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('achievement_id', achievementId)
        .maybeSingle();

    return result != null;
  }

  Future<bool> toggleAchievementBookmark(String achievementId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final existing = await _client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('achievement_id', achievementId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('achievement_id', achievementId);
      return false;
    } else {
      await _client.from('bookmarks').insert({
        'user_id': userId,
        'achievement_id': achievementId,
      });
      return true;
    }
  }
}

