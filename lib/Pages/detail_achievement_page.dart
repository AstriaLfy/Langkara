import 'package:flutter/material.dart';
import 'package:langkara/models/achievement_model.dart';
import 'package:langkara/services/interaction_service.dart';
import 'package:langkara/widgets/comment_bottom_sheet.dart';

class DetailAchievementPage extends StatefulWidget {
  final AchievementModel achievement;
  final String? authorName;
  final String? authorAvatar;
  final String? authorJurusan;
  final String? authorUniversitas;

  const DetailAchievementPage({
    super.key,
    required this.achievement,
    this.authorName,
    this.authorAvatar,
    this.authorJurusan,
    this.authorUniversitas,
  });

  @override
  State<DetailAchievementPage> createState() => _DetailAchievementPageState();
}

class _DetailAchievementPageState extends State<DetailAchievementPage> {
  final InteractionService _interactionService = InteractionService();

  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likeCount = 0;
  bool _isLoadingInteraction = true;

  @override
  void initState() {
    super.initState();
    _loadInteractionStatus();
  }

  Future<void> _loadInteractionStatus() async {
    try {
      final liked =
          await _interactionService.isAchievementLiked(widget.achievement.id);
      final bookmarked =
          await _interactionService.isAchievementBookmarked(widget.achievement.id);
      final count =
          await _interactionService.getAchievementLikeCount(widget.achievement.id);
      if (mounted) {
        setState(() {
          _isLiked = liked;
          _isBookmarked = bookmarked;
          _likeCount = count;
          _isLoadingInteraction = false;
        });
      }
    } catch (e) {
      debugPrint("Error loadInteractionStatus: $e");
      if (mounted) setState(() => _isLoadingInteraction = false);
    }
  }

  Future<void> _handleLike() async {
    final prevState = _isLiked;
    final prevCount = _likeCount;
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    try {
      await _interactionService.toggleAchievementLike(widget.achievement.id);
    } catch (e) {
      debugPrint("Error handleLike: $e");
      if (mounted) {
        setState(() {
          _isLiked = prevState;
          _likeCount = prevCount;
        });
      }
    }
  }

  Future<void> _handleBookmark() async {
    final prevState = _isBookmarked;
    setState(() => _isBookmarked = !_isBookmarked);
    try {
      await _interactionService.toggleAchievementBookmark(widget.achievement.id);
    } catch (e) {
      debugPrint("Error handleBookmark: $e");
      if (mounted) setState(() => _isBookmarked = prevState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pencapaian",
          style: TextStyle(
            color: Color(0xFF1A2A4F),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE8E8E8),
                    backgroundImage: widget.authorAvatar != null
                        ? NetworkImage(widget.authorAvatar!)
                        : null,
                    child: widget.authorAvatar == null
                        ? const Icon(Icons.person, size: 20,
                            color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.authorName ?? 'Anonim',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1A2A4F),
                      ),
                    ),
                  ),
                  const Icon(Icons.more_vert,
                      color: Color(0xFF1A2A4F), size: 20),
                ],
              ),
            ),

            // Certificate image
            if (achievement.certificateImageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    achievement.certificateImageUrl!,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48),
                      ),
                    ),
                  ),
                ),
              ),

            // Action buttons: like, comment, bookmark
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                      size: 26,
                    ),
                    onPressed:
                        _isLoadingInteraction ? null : _handleLike,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: () {
                      showCommentBottomSheet(context,
                          achievementId: widget.achievement.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.black,
                      size: 26,
                    ),
                    onPressed:
                        _isLoadingInteraction ? null : _handleBookmark,
                  ),
                ],
              ),
            ),

            // Like count
            if (_likeCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "$_likeCount suka",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1A2A4F),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                achievement.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1A2A4F),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Jurusan + Universitas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${widget.authorJurusan ?? '-'}, ${widget.authorUniversitas ?? '-'}",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            // Description
            if (achievement.description != null &&
                achievement.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  achievement.description!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
