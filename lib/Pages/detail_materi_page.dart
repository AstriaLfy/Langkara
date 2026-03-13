import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:langkara/repository/materi_repository.dart';
import 'package:langkara/services/materi_service.dart';
import 'package:langkara/services/interaction_service.dart';
import 'package:langkara/widgets/comment_bottom_sheet.dart';

class DetailMateriPage extends StatefulWidget {
  final String materiId;

  const DetailMateriPage({super.key, required this.materiId});

  @override
  State<DetailMateriPage> createState() => _DetailMateriPageState();
}

class _DetailMateriPageState extends State<DetailMateriPage> {
  final InteractionService _interactionService = InteractionService();
  int _currentImageIndex = 0;
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
      final liked = await _interactionService.isLiked(widget.materiId);
      final bookmarked = await _interactionService.isBookmarked(widget.materiId);
      final count = await _interactionService.getLikeCount(widget.materiId);
      if (mounted) {
        setState(() {
          _isLiked = liked;
          _isBookmarked = bookmarked;
          _likeCount = count;
          _isLoadingInteraction = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingInteraction = false);
    }
  }

  Future<void> _handleLike() async {
    final previousState = _isLiked;
    final previousCount = _likeCount;
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    try {
      await _interactionService.toggleLike(widget.materiId);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLiked = previousState;
          _likeCount = previousCount;
        });
      }
    }
  }

  Future<void> _handleBookmark() async {
    final previousState = _isBookmarked;
    setState(() => _isBookmarked = !_isBookmarked);
    try {
      await _interactionService.toggleBookmark(widget.materiId);
    } catch (_) {
      if (mounted) setState(() => _isBookmarked = previousState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MateriBloc(MateriRepository(MateriService()))
            ..add(LoadMateriDetail(widget.materiId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Materi",
            style: TextStyle(
              color: Color(0xFF1A2A4F),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MateriError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<MateriBloc>()
                            .add(LoadMateriDetail(widget.materiId)),
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is MateriDetailLoaded) {
              return _buildDetailContent(state.materi);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(MateriFeedModel materi) {
    final List<String> imageUrls = _getImageUrls(materi);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === HEADER: Avatar + Username ===
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE8E8E8),
                  backgroundImage: materi.authorAvatar != null
                      ? NetworkImage(materi.authorAvatar!)
                      : null,
                  child: materi.authorAvatar == null
                      ? const Icon(Icons.person,
                          size: 22, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    materi.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1A2A4F),
                    ),
                  ),
                ),
                const Icon(Icons.more_vert, color: Color(0xFF1A2A4F)),
              ],
            ),
          ),

          // === IMAGE SLIDER WITH OVERLAY TEXT ===
          if (imageUrls.isNotEmpty) _buildImageSlider(imageUrls, materi),

          // === ACTION BUTTONS: Like, Comment, Bookmark ===
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
                  onPressed: _isLoadingInteraction ? null : _handleLike,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    showCommentBottomSheet(context,
                        materiId: widget.materiId);
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.black,
                    size: 26,
                  ),
                  onPressed: _isLoadingInteraction ? null : _handleBookmark,
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

          // === INFO SECTION ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  materi.judul,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),

                // Sumber
                Text(
                  "Sumber : ${materi.sumberReferensi ?? '-'}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),

                // Jurusan, Universitas
                Text(
                  "${materi.authorJurusan ?? '-'}, ${materi.authorUniversitas ?? '-'}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls, MateriFeedModel materi) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress
                                            .cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 48, color: Colors.grey),
                      ),
                    ),
                  ),


                ],
              );
            },
          ),
        ),

        // Dot Indicator
        if (imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? const Color(0xFFE74C3C)
                        : Colors.grey[350],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<String> _getImageUrls(MateriFeedModel materi) {
    if (materi.allImages != null && materi.allImages!.isNotEmpty) {
      return materi.allImages!.map((e) => e.toString()).toList();
    }
    if (materi.coverUrl != null && materi.coverUrl!.isNotEmpty) {
      return [materi.coverUrl!];
    }
    return [];
  }
}