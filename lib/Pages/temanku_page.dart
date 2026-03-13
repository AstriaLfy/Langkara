import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Temanku/teman_bloc.dart';
import 'package:langkara/Pages/room_chat_page.dart';
import 'package:langkara/Pages/profile_detail_page.dart';
import 'package:langkara/models/teman_profile_model.dart';
import 'package:langkara/repository/teman_repository.dart';
import 'package:langkara/services/teman_service.dart';

class TemankuPage extends StatefulWidget {
  const TemankuPage({super.key});

  @override
  State<TemankuPage> createState() => _TemankuPageState();
}

class _TemankuPageState extends State<TemankuPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TemanBloc(TemanRepository(TemanService()))..add(LoadTemanList()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<TemanBloc, TemanState>(
            builder: (context, state) {
              if (state is TemanLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TemanError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<TemanBloc>()
                              .add(LoadTemanList()),
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is TemanLoaded) {
                if (state.temanList.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada partner tersedia saat ini"),
                  );
                }
                return _buildContent(state.temanList);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<TemanProfileModel> temanList) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
          child: Text(
            "Ayo cari partner yang cocok dengan kamu!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2A4F),
              height: 1.3,
            ),
          ),
        ),

        // Horizontal PageView carousel
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: temanList.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                controller: _pageController,
                index: index,
                child: _buildTemanCard(temanList[index]),
              );
            },
          ),
        ),

        // Kirim Pesan button
        Padding(
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          child: GestureDetector(
            onTap: () {
              final teman = temanList[_currentIndex];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomChatPage(
                    otherUserId: teman.id,
                    otherUserName: teman.username,
                    otherUserAvatar: teman.avatarUrl,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 35, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A2A4F).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Kirim Pesan ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.send, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemanCard(TemanProfileModel teman) {
    // Parse kemampuan from comma-separated string
    List<String> kemampuanList = [];
    if (teman.kemampuan != null && teman.kemampuan!.isNotEmpty) {
      kemampuanList = teman.kemampuan!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileDetailPage(
              userId: teman.id,
              username: teman.username,
              avatarUrl: teman.avatarUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === PINK BANNER + AVATAR ===
                SizedBox(
                  height: 160,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Pink banner
                      Container(
                        height: 110,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF8B4B4),
                              Color(0xFFF2A0A0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      // Avatar
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: const Color(0xFFE8E8E8),
                            backgroundImage: teman.avatarUrl != null
                                ? NetworkImage(teman.avatarUrl!)
                                : null,
                            child: teman.avatarUrl == null
                                ? const Icon(Icons.person,
                                    size: 36, color: Colors.grey)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // === NAME + USERNAME ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: teman.nama ?? teman.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2A4F),
                          ),
                        ),
                        TextSpan(
                          text: " / @${teman.username}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // === JURUSAN + UNIVERSITAS ===
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "${teman.jurusan ?? '-'}, ${teman.universitas ?? '-'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                // === GENDER ===
                if (teman.gender != null && teman.gender!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      teman.gender!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // === PENCAPAIAN ===
                if (teman.pencapaian.isNotEmpty)
                  _buildSection(
                    title: "Pencapaian",
                    items: teman.pencapaian,
                    color: const Color(0xFFFFF3E0),
                  ),

                const SizedBox(height: 10),

                // === KEMAMPUAN ===
                _buildSection(
                  title: "Kemampuan",
                  items: kemampuanList,
                  color: const Color(0xFFFFF9C4),
                  emptyText: "Belum ditambahkan",
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required Color color,
    String? emptyText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1A2A4F),
              ),
            ),
            const SizedBox(height: 6),
            if (items.isNotEmpty)
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("•  ",
                          style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                emptyText ?? "-",
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget that provides scale animation for the PageView cards
class AnimatedBuilder extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const AnimatedBuilder({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder._builder(controller, index, child);
  }

  static Widget _builder(
      PageController controller, int index, Widget child) {
    double value = 1.0;
    if (controller.position.haveDimensions) {
      double page = controller.page ?? controller.initialPage.toDouble();
      value = (1 - (page - index).abs() * 0.10).clamp(0.75, 1.0);
    }
    return Transform.scale(
      scale: value,
      child: child,
    );
  }
}