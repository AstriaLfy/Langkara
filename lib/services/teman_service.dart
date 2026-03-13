import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/teman_profile_model.dart';

class TemanService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TemanProfileModel>> getTemanList() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw Exception("User tidak terautentikasi");
    }

    final response = await _client
        .from('profiles')
        .select('''
          id,
          username,
          nama,
          jurusan,
          universitas,
          avatar_url,
          gender,
          kemampuan,
          total_xp,
          tiket_baca_sisa,
          is_banned,
          created_at,
          last_login,
          achievements(
            id,
            user_id,
            title,
            description,
            category,
            certificate_image_url,
            achieved_at,
            created_at
          )
        ''')
        .neq('id', currentUser.id)
        .eq('is_banned', false);

    return (response as List)
        .map((e) => TemanProfileModel.fromJson(e))
        .toList();
  }
}
