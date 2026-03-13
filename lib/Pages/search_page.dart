import 'package:flutter/material.dart';
import 'package:langkara/services/search_service.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:langkara/models/inspirasi_model.dart';
import 'package:langkara/models/berita_model.dart';
import 'package:langkara/Pages/detail_materi_page.dart';
import 'package:langkara/Pages/detail_inspirasi_page.dart';
import 'package:langkara/Pages/detail_berita_page.dart';
import 'package:langkara/Pages/profile_detail_page.dart';
import 'package:langkara/services/ticket_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // Data
  List<Map<String, dynamic>> _temanResults = [];
  List<BeritaModel> _beritaResults = [];
  List<MateriFeedModel> _materiResults = [];
  List<InspirasiModel> _inspirasiResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _searchService.getAllTeman(),
        _searchService.getAllBerita(),
        _searchService.getAllMateri(),
        _searchService.getAllInspirasi(),
      ]);
      if (mounted) {
        setState(() {
          _temanResults = results[0] as List<Map<String, dynamic>>;
          _beritaResults = results[1] as List<BeritaModel>;
          _materiResults = results[2] as List<MateriFeedModel>;
          _inspirasiResults = results[3] as List<InspirasiModel>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    setState(() => _isLoading = true);

    try {
      if (query.isEmpty) {
        await _loadAll();
        return;
      }

      final results = await Future.wait([
        _searchService.searchTeman(query),
        _searchService.searchBerita(query),
        _searchService.searchMateri(query),
        _searchService.searchInspirasi(query),
      ]);

      if (mounted) {
        setState(() {
          _temanResults = results[0] as List<Map<String, dynamic>>;
          _beritaResults = results[1] as List<BeritaModel>;
          _materiResults = results[2] as List<MateriFeedModel>;
          _inspirasiResults = results[3] as List<InspirasiModel>;
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
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 12, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color(0xFF1A2A4F)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Cari ...",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search,
                              color: Color(0xFF1A2A4F)),
                        ),
                        onSubmitted: (_) => _performSearch(),
                        onChanged: (val) {
                          if (val.isEmpty) _loadAll();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.tune,
                        color: Color(0xFF1A2A4F), size: 20),
                  ),
                ],
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1A2A4F),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              indicatorColor: const Color(0xFF1A2A4F),
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: "Teman"),
                Tab(text: "Berita"),
                Tab(text: "Materi"),
                Tab(text: "Inspirasi"),
              ],
            ),

            // Tab content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTemanTab(),
                        _buildBeritaTab(),
                        _buildMateriTab(),
                        _buildInspirasiTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TEMAN TAB ====================
  Widget _buildTemanTab() {
    if (_temanResults.isEmpty) {
      return const Center(
          child: Text("Tidak ada hasil",
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _temanResults.length,
      itemBuilder: (context, index) {
        final teman = _temanResults[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileDetailPage(
                  userId: teman['id'],
                  username: teman['username'] ?? 'Anonim',
                  avatarUrl: teman['avatar_url'],
                ),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE8E8E8),
            backgroundImage: teman['avatar_url'] != null
                ? NetworkImage(teman['avatar_url'])
                : null,
            child: teman['avatar_url'] == null
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          title: Text(
            teman['username'] ?? 'Anonim',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF1A2A4F),
            ),
          ),
          subtitle: Text(
            "${teman['jurusan'] ?? '-'}, ${teman['universitas'] ?? '-'}",
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        );
      },
    );
  }

  // ==================== BERITA TAB ====================
  Widget _buildBeritaTab() {
    if (_beritaResults.isEmpty) {
      return const Center(
          child: Text("Tidak ada berita",
              style: TextStyle(color: Colors.grey)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Berita Terbaru (first item featured)
          Text(
            "Berita Terbaru",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),

          // Featured berita card
          GestureDetector(
            onTap: () => _navigateToBeritaDetail(_beritaResults.first),
            child: _buildFeaturedBeritaCard(_beritaResults.first),
          ),

          const SizedBox(height: 20),

          // Artikel section
          if (_beritaResults.length > 1) ...[
            Text(
              "Artikel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),

            // List of articles
            ...List.generate(
              _beritaResults.length - 1,
              (i) {
                final berita = _beritaResults[i + 1];
                return GestureDetector(
                  onTap: () => _navigateToBeritaDetail(berita),
                  child: _buildArticleItem(berita),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturedBeritaCard(BeritaModel berita) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: berita.photoUrl != null
              ? Image.network(
                  berita.photoUrl!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(
                        child: Icon(Icons.article, size: 48)),
                  ),
                )
              : Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(
                      child: Icon(Icons.article, size: 48)),
                ),
        ),
        const SizedBox(height: 10),
        // Date
        Text(
          berita.formattedDate,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        const SizedBox(height: 4),
        // Title
        Text(
          berita.judul,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A2A4F),
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildArticleItem(BeritaModel berita) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: berita.photoUrl != null
                ? Image.network(
                    berita.photoUrl!,
                    width: 90,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 75,
                      color: Colors.grey[200],
                      child: const Icon(Icons.article),
                    ),
                  )
                : Container(
                    width: 90,
                    height: 75,
                    color: Colors.grey[200],
                    child: const Icon(Icons.article),
                  ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  berita.formattedDate,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 3),
                Text(
                  berita.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A2A4F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${berita.sumber ?? '-'} · 5 menit dibaca",
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBeritaDetail(BeritaModel berita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailBeritaPage(berita: berita),
      ),
    );
  }

  // ==================== MATERI TAB ====================
  Widget _buildMateriTab() {
    if (_materiResults.isEmpty) {
      return const Center(
          child: Text("Tidak ada hasil",
              style: TextStyle(color: Colors.grey)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.52,
      ),
      itemCount: _materiResults.length,
      itemBuilder: (context, index) {
        final materi = _materiResults[index];
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
          child: _buildMateriSearchCard(materi),
        );
      },
    );
  }

  Widget _buildMateriSearchCard(MateriFeedModel materi) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                        fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.more_vert, size: 18),
              ],
            ),
          ),
          // Thumbnail with overlay
          Expanded(
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
                  left: 10,
                  bottom: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("MATERI :",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1)),
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
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(materi.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  "Sumber : ${materi.sumberReferensi ?? materi.authorName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                ),
                const SizedBox(height: 2),
                Text(
                  "${materi.authorJurusan ?? '-'}, ${materi.authorUniversitas ?? '-'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== INSPIRASI TAB ====================
  Widget _buildInspirasiTab() {
    if (_inspirasiResults.isEmpty) {
      return const Center(
          child: Text("Tidak ada hasil",
              style: TextStyle(color: Colors.grey)));
    }

    final featured = _inspirasiResults.first;
    final gridItems = _inspirasiResults.length > 1
        ? _inspirasiResults.sublist(1)
        : <InspirasiModel>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === TERBARU SECTION ===
          const Text(
            "Terbaru",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A2A4F),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DetailInspirasiPage(inspirasi: featured),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: featured.photoUrl != null
                      ? Image.network(
                          featured.photoUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.person,
                                  size: 48, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.person,
                                size: 48, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                // Profesi as location hint
                Text(
                  featured.profesi,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                // Description / nama as title
                Text(
                  "Yuk kenalan dengan ${featured.nama} dengan segudang prestasinya!",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2A4F),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // === INSPIRASI GRID SECTION ===
          if (gridItems.isNotEmpty) ...[
            const Text(
              "Inspirasi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A2A4F),
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                final inspirasi = gridItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailInspirasiPage(
                            inspirasi: inspirasi),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.grey[200]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(
                                    top: Radius.circular(14)),
                            child: inspirasi.photoUrl != null
                                ? Image.network(
                                    inspirasi.photoUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) =>
                                            Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                            Icons.person,
                                            size: 36,
                                            color:
                                                Colors.grey),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.person,
                                          size: 36,
                                          color: Colors.grey),
                                    ),
                                  ),
                          ),
                        ),
                        // Info
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                inspirasi.nama,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1A2A4F),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                inspirasi.profesi,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle:
                                      FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
