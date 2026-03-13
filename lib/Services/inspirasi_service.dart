import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class InspirasiService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<dynamic>> getRandomInspirasi() async {
    final data = await _client
        .from('inspirasi')
        .select();

    if (data.isEmpty) {
      return [];
    }

    data.shuffle(Random());

    return data.take(2).toList();
}
}