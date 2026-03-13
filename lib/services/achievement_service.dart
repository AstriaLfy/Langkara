import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AchievementService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> uploadAchievement({
    required String title,
    required String description,
    required String category,
    required String imagePath,
    required String achievedAt,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception("User tidak terautentikasi");

    // Upload certificate image
    final file = File(imagePath);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final pathInStorage = 'achievements/${user.id}/$fileName';

    await _client.storage
        .from('materi_bucket')
        .upload(pathInStorage, file);

    final imageUrl = _client.storage
        .from('materi_bucket')
        .getPublicUrl(pathInStorage);

    // Insert to achievements table
    await _client.from('achievements').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'category': category,
      'certificate_image_url': imageUrl,
      'achieved_at': achievedAt,
    });
  }
}
