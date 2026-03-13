import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:langkara/models/achievement_model.dart';
import 'package:langkara/Pages/detail_materi_page.dart';
import 'package:langkara/Pages/detail_achievement_page.dart';
import 'package:langkara/Pages/room_chat_page.dart';
import 'package:langkara/services/ticket_service.dart';

class ProfileDetailPage extends StatefulWidget {
  final String userId;
  final String username;
  final String? avatarUrl;

  const ProfileDetailPage({
    super.key,
    required this.userId,
    required this.username,
    this.avatarUrl,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage>
    with SingleTickerProviderStateMixin {
  final SupabaseClient _client = Supabase.instance.client;
  late TabController _tabController;

  Map<String, dynamic>? _profile;
  List<MateriFeedModel> _materiList = [];
  List<AchievementModel> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profileFuture = _client
          .from('profiles')
          .select('username, jurusan, universitas, avatar_url, gender')
          .eq('id', widget.userId)
          .maybeSingle();

      final materiFuture = _client
          .from('materi')
          .select('''
            id,
            judul,
            jurusan,
            universitas,
            cover_url,
            sumber_referensi,
            profiles!materi_author_id_fkey(
              username,
              avatar_url,
              jurusan,
              universitas
            )
          ''')
          .eq('author_id', widget.userId)
          .order('created_at', ascending: false);

      final achievementFuture = _client
          .from('achievements')
          .select()
          .eq('user_id', widget.userId)
          .order('achieved_at', ascending: false);

      final results = await Future.wait([
        profileFuture,
        materiFuture,
        achievementFuture,
      ]);

      if (mounted) {
        setState(() {
          _profile = results[0] as Map<String, dynamic>?;
          _materiList = (results[1] as List)
              .map((e) => MateriFeedModel.fromJson(e))
              .toList();
          _achievements = (results[2] as List)
              .map((e) => AchievementModel.fromJson(e))
              .toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.username,
          style: const TextStyle(
            color: Color(0xFF1A2A4F),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1A2A4F)),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile info section
                _buildProfileInfo(),

                // Kirim Pesan button
                _buildSendMessageButton(),

                const SizedBox(height: 12),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1A2A4F),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF1A2A4F),
                  indicatorWeight: 2.5,
                  tabs: const [
                    Tab(icon: Icon(Icons.auto_stories_outlined)),
                    Tab(icon: Icon(Icons.emoji_events_outlined)),
                  ],
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMateriTab(),
                      _buildAchievementsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileInfo() {
    final name = _profile?['username'] ?? widget.username;
    final jurusan = _profile?['jurusan'] ?? '-';
    final universitas = _profile?['universitas'] ?? '-';
    final gender = _profile?['gender'];
    final avatar = _profile?['avatar_url'] ?? widget.avatarUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Avatar with add icon
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xFFE8E8E8),
                backgroundImage:
                    avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null
                    ? const Icon(Icons.person, size: 36, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E3159),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A2A4F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  jurusan,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                Text(
                  universitas,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                if (gender != null && gender.toString().isNotEmpty)
                  Text(
                    gender,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessageButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 160,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RoomChatPage(
                  otherUserId: widget.userId,
                  otherUserName: _profile?['username'] ?? widget.username,
                  otherUserAvatar:
                      _profile?['avatar_url'] ?? widget.avatarUrl,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE8A0A0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 0,
          ),
          child: const Text(
            "Kirim Pesan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ),
    );
  }

  // ==================== MATERI TAB ====================
  Widget _buildMateriTab() {
    if (_materiList.isEmpty) {
      return const Center(
        child: Text("Belum ada materi",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 0.8,
      ),
      itemCount: _materiList.length,
      itemBuilder: (context, index) {
        final materi = _materiList[index];
        return GestureDetector(
          onTap: () async {
            final canAccess = await checkAndUseTicket(context);
            if (!canAccess || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailMateriPage(materiId: materi.id),
              ),
            );
          },
          child: _buildMateriThumbnail(materi),
        );
      },
    );
  }

  Widget _buildMateriThumbnail(MateriFeedModel materi) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          materi.coverUrl ?? "",
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFF1A2A4F).withValues(alpha: 0.85),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MATERI :",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(
                materi.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== ACHIEVEMENTS TAB ====================
  Widget _buildAchievementsTab() {
    if (_achievements.isEmpty) {
      return const Center(
        child: Text("Belum ada pencapaian",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 0.8,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailAchievementPage(
                  achievement: achievement,
                  authorName: _profile?['username'] ?? widget.username,
                  authorAvatar: _profile?['avatar_url'] ?? widget.avatarUrl,
                  authorJurusan: _profile?['jurusan'],
                  authorUniversitas: _profile?['universitas'],
                ),
              ),
            );
          },
          child: _buildAchievementThumbnail(achievement),
        );
      },
    );
  }

  Widget _buildAchievementThumbnail(AchievementModel achievement) {
    return achievement.certificateImageUrl != null
        ? Image.network(
            achievement.certificateImageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.emoji_events,
                    size: 32, color: Colors.amber),
              ),
            ),
          )
        : Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.emoji_events,
                  size: 32, color: Colors.amber),
            ),
          );
  }
}
