import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    return await getProfile(user.id);
  }

  Future<void> updateProfile({
    required String jurusan,
    required String universitas,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _client.from('profiles').update({
      'jurusan': jurusan,
      'universitas': universitas,
    }).eq('id', user.id);
  }

  Future<void> addXP(int xp) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _client.rpc('increment_xp', params: {
      'user_id': user.id,
      'xp_amount': xp,
    });
  }

  Future<void> useTicket() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _client.from('profiles')
        .update({
      'tiket_baca_sisa': 1
    })
        .eq('id', user.id);
  }
}