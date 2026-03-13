import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  Future<Map<String, int>> getTicketInfo() async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("User tidak terautentikasi");

    final profile = await _client
        .from('profiles')
        .select('tiket_baca_sisa, total_xp, last_ticket_reset')
        .eq('id', userId)
        .single();

    int tiketSisa = profile['tiket_baca_sisa'] ?? 0;
    final totalXp = profile['total_xp'] ?? 0;

    final lastReset = profile['last_ticket_reset'] != null
        ? DateTime.tryParse(profile['last_ticket_reset'])
        : null;
    final now = DateTime.now();

    if (lastReset == null ||
        now.year != lastReset.year ||
        now.month != lastReset.month ||
        now.day != lastReset.day) {
      tiketSisa = 2;
      await _client.from('profiles').update({
        'tiket_baca_sisa': 2,
        'last_ticket_reset': now.toIso8601String(),
      }).eq('id', userId);
    }

    return {
      'tiket_baca_sisa': tiketSisa,
      'total_xp': totalXp,
    };
  }

  Future<bool> useTicket() async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final info = await getTicketInfo();
    if (info['tiket_baca_sisa']! <= 0) return false;

    await _client.from('profiles').update({
      'tiket_baca_sisa': info['tiket_baca_sisa']! - 1,
    }).eq('id', userId);

    return true;
  }

  Future<bool> useXpCoins() async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final info = await getTicketInfo();
    if (info['total_xp']! < 40) return false;

    await _client.from('profiles').update({
      'total_xp': info['total_xp']! - 40,
    }).eq('id', userId);

    return true;
  }
}

Future<bool> checkAndUseTicket(BuildContext context) async {
  final ticketService = TicketService();

  try {
    final info = await ticketService.getTicketInfo();
    final tiketSisa = info['tiket_baca_sisa']!;
    final totalXp = info['total_xp']!;

    if (tiketSisa > 0) {
      await ticketService.useTicket();
      return true;
    }

    if (!context.mounted) return false;
    final wantUseXp = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TicketHabisDialog(),
    );

    if (wantUseXp != true) return false;

    if (totalXp < 40) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("XP kamu tidak cukup (butuh 40 XP)"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!context.mounted) return false;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _UseXpDialog(),
    );

    if (confirmed != true) return false;

    final success = await ticketService.useXpCoins();
    if (!success) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menggunakan XP. Coba lagi."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  } catch (e) {
    return true;
  }
}


class _TicketHabisDialog extends StatelessWidget {
  static const _gradient = LinearGradient(
    colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Tiket bacamu hari ini\nsudah habis, silahkan\ngunakan poin xp.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1A2A4F),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(
                          color: Color(0xFF1A2A4F), width: 1.5),
                    ),
                    child: const Text(
                      "Kembali",
                      style: TextStyle(
                        color: Color(0xFF1A2A4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _gradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Lanjutkan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UseXpDialog extends StatelessWidget {
  static const _gradient = LinearGradient(
    colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Apakah anda akan\nmenggunakan koin sebesar\n40xp?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1A2A4F),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(
                          color: Color(0xFF1A2A4F), width: 1.5),
                    ),
                    child: const Text(
                      "Tidak",
                      style: TextStyle(
                        color: Color(0xFF1A2A4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _gradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Iya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
