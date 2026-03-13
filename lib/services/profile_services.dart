  import 'package:supabase_flutter/supabase_flutter.dart';

  class ProfileService {
    final SupabaseClient _client = Supabase.instance.client;

    Future<Map<String, dynamic>> getProfile(String userId) async {
      return await _client.from('profiles').select().eq('id', userId).single();
    }

    Future<Map<String, dynamic>> getCurrentUserProfile() async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      return await getProfile(user.id);
    }
  Future<int> getUserXP() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final data = await _client
        .from('profiles')
        .select('total_xp')
        .eq('id', user.id)
        .single();

    return data['total_xp'] ?? 0;
  }

    Future<void> updateProfile({
      String? nama,
      String? username,
      String? email,
      String? jurusan,
      String? universitas,
      String? gender,
      String? kemampuan,
      String? avatarUrl,
    }) async {
      final user = _client.auth.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final data = <String, dynamic>{};

      if (nama != null && nama.trim().isNotEmpty) {
        data['nama'] = nama;
      }

      if (username != null && username.trim().isNotEmpty) {
        data['username'] = username;
      }

      if (email != null && email.trim().isNotEmpty) {
        data['email'] = email;
      }

      if (jurusan != null && jurusan.trim().isNotEmpty) {
        data['jurusan'] = jurusan;
      }

      if (universitas != null && universitas.trim().isNotEmpty) {
        data['universitas'] = universitas;
      }

      if (gender != null && gender.trim().isNotEmpty) {
        data['gender'] = gender;
      }

      if (kemampuan != null && kemampuan.trim().isNotEmpty) {
        data['kemampuan'] = kemampuan;
      }

      if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
        data['avatar_url'] = avatarUrl;
      }

      if (data.isEmpty) return;

      await _client.from('profiles').update(data).eq('id', user.id);
    }

    Future<void> addXP(int xp) async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await _client.rpc(
        'increment_xp',
        params: {'user_id': user.id, 'xp_amount': xp},
      );
    }

    Future<void> useTicket() async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await _client
          .from('profiles')
          .update({'tiket_baca_sisa': 1})
          .eq('id', user.id);
    }
  }
