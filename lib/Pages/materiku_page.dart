import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/Pages/Widgets/app_bar.dart';
import 'package:langkara/Pages/Widgets/materi_card.dart';
import 'package:langkara/repository/materi_repository.dart';
import 'package:langkara/services/materi_service.dart';
import 'package:langkara/Pages/detail_materi_page.dart';
import 'package:langkara/Pages/search_page.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:langkara/services/ticket_service.dart';

class MateriKuPage extends StatelessWidget {
  const MateriKuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MateriBloc(MateriRepository(MateriService()))..add(LoadMateriFeed()),
      child: Scaffold(
        appBar: MyCustomAppBar(),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MateriLoaded) {
              final materiList = state.materi;

              if (materiList.isEmpty) {
                return const Center(child: Text("Belum ada materi"));
              }

              // Get 2 random recommendations
              final recommendations = _getRecommendations(materiList, 2);

              return CustomScrollView(
                slivers: [


                  // Rekomendasi Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 16, bottom: 8),
                      child: Text(
                        "Rekomendasi untuk kamu",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),

                  // Rekomendasi Cards (2 items)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: recommendations.map((materi) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              child: GestureDetector(
                                onTap: () => _navigateToDetail(
                                    context, materi.id),
                                child: _buildRecommendationCard(materi),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Semua Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 20, bottom: 8),
                      child: Text(
                        "Semua",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),

                  // Semua Grid
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.55,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final materi = materiList[index];
                          return GestureDetector(
                            onTap: () =>
                                _navigateToDetail(context, materi.id),
                            child: MateriCard(materi: materi),
                          );
                        },
                        childCount: materiList.length,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is MateriError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  List<MateriFeedModel> _getRecommendations(
      List<MateriFeedModel> allMateri, int count) {
    if (allMateri.length <= count) return allMateri;
    final shuffled = List<MateriFeedModel>.from(allMateri)..shuffle(Random());
    return shuffled.take(count).toList();
  }

  void _navigateToDetail(BuildContext context, String materiId) async {
    final canAccess = await checkAndUseTicket(context);
    if (!canAccess) return;
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMateriPage(materiId: materiId),
      ),
    );
  }

  Widget _buildRecommendationCard(MateriFeedModel materi) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + name + more
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: materi.authorAvatar != null
                      ? NetworkImage(materi.authorAvatar!)
                      : null,
                  child: materi.authorAvatar == null
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    materi.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.more_vert, size: 18),
              ],
            ),
          ),

          // Thumbnail with overlay
          AspectRatio(
            aspectRatio: 0.9,
            child: Stack(
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
                // Dark gradient overlay
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
                // Overlay text
                Positioned(
                  left: 10,
                  bottom: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "MATERI :",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        materi.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  materi.judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Sumber : ${materi.sumberReferensi ?? materi.authorName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${materi.authorJurusan ?? '-'}, ${materi.authorUniversitas ?? '-'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}