import 'package:flutter/material.dart';
import 'package:langkara/Pages/search_page.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showSearchBar;
  final bool showBackButton;

  const MyCustomAppBar({
    super.key,
    this.title,
    this.showSearchBar = true,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(showSearchBar ? 140.0 : 100.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E335A), Color(0xFF454B7A), Color(0xFF8B6B8A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (title != null)
                Row(
                  children: [
                    if (showBackButton)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 24),
                      ),
                    if (showBackButton) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title!,
                        textAlign: showBackButton
                            ? TextAlign.left
                            : TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (showBackButton) const SizedBox(width: 36),
                  ],
                ),

              if (title != null && showSearchBar)
                const SizedBox(height: 12),

              if (showSearchBar)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Cari materi, catatan...",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const Icon(Icons.search,
                            color: Color(0xFF1A2A4F)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}