import 'package:flutter/material.dart';
import 'package:langkara/Pages/home_page.dart';
import 'package:langkara/Pages/materiku_page.dart';
import 'package:langkara/Pages/profile_page.dart';
import 'package:langkara/Pages/temanku_page.dart';
import 'package:langkara/Pages/upload_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/reading/reading_bloc.dart';
import 'package:langkara/Services/reading_service.dart';
import 'package:langkara/Bloc/profile_tab/profile_materi_bloc.dart';
import 'package:langkara/Bloc/profile_tab/profile_achievement_bloc.dart';
import 'package:langkara/Bloc/profile_tab/profile_bookmark_bloc.dart';
import 'package:langkara/Services/profile_tab_services.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MaterikuPage(),
    const UploadPage(),
    const TemankuPage(),
    MultiBlocProvider(
    providers: [

      BlocProvider(
        create: (_) => ProfileMateriBloc(ProfileTabService())
          ..add(LoadProfileMateri()),
      ),

      BlocProvider(
        create: (_) => ProfileAchievementBloc(ProfileTabService())
          ..add(LoadProfileAchievement()),
      ),

      BlocProvider(
        create: (_) => ProfileBookmarkBloc(ProfileTabService())
          ..add(LoadProfileBookmark()),
      ), 
    ],
    child: const ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF1A2A4F),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Materiku',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 38),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_outlined),
              label: 'Temanku',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
