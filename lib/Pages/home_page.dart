import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:langkara/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langkara/Bloc/Ticket/ticket_bloc.dart';
import 'package:langkara/Bloc/Reading/reading_bloc.dart';
import 'package:langkara/Services/reading_service.dart';
import 'package:langkara/Bloc/search/search_bloc.dart';
import 'package:langkara/Services/inspirasi_service.dart';
import 'package:langkara/Services/profile_services.dart';
import 'package:langkara/Services/berita_service.dart';
import 'package:langkara/utils/date_helper.dart';
import 'package:langkara/Pages/chat_history_page.dart';
import 'package:langkara/Pages/search_page.dart';

void showXpDialog(BuildContext context) async {
  final profileService = ProfileService();

  final profile = await profileService.getCurrentUserProfile();
  final int total_xp = profile['total_xp'] ?? 0;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xffEDEDED),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// background coin kiri
                  Positioned(
                    left: -20,
                    bottom: 70,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.monetization_on,
                        size: 90,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  /// background coin kanan
                  Positioned(
                    right: -20,
                    top: 60,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.monetization_on,
                        size: 90,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/koin.png", width: 70),

                      const SizedBox(height: 16),

                      const Text(
                        "Jumlah koin anda",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE99A9A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$total_xp XP",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Semangat upload materi agar\nkoinmu bertambah!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xff1A2A4F), Color(0xffDD979B)],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Kembali",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                ),
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
          ),
        ),
      );
    },

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Home Page Sementara"),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Cari materi...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LihatSemuaText extends StatefulWidget {
  final VoidCallback onTap;

  const LihatSemuaText({super.key, required this.onTap});

  @override
  State<LihatSemuaText> createState() => _LihatSemuaTextState();
}

class _LihatSemuaTextState extends State<LihatSemuaText> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (value) {
        setState(() {
          isPressed = value;
        });
      },
      child: Text(
        'Lihat semua',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          color: colors.blue,
          fontSize: 12,
          decoration: isPressed
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}

class MateriCard extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final String kategori;
  final String materi;
  final String judul;
  final String sumber;

  const MateriCard({
    super.key,
    this.width = 167,
    this.height = 220,
    required this.imageUrl,
    required this.kategori,
    required this.materi,
    required this.judul,
    required this.sumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 60,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color.fromARGB(153, 0, 0, 0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                /// kategori
                Positioned(
                  top: 7,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),

                /// text materi
                Positioned(
                  left: 12,
                  bottom: 20,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'MATERI: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: materi,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //bagian bawah
          Expanded(
            flex: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: colors.blue,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sumber,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Inpirasi Card
class InspirasiCard extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final String nama;
  final String deskripsi;

  const InspirasiCard({
    super.key,
    this.width = 167,
    this.height = 170,
    required this.imageUrl,
    this.deskripsi = " ",
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 54,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          //bagian bawah
          Expanded(
            flex: 46,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    textAlign: TextAlign.start,
                    deskripsi,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BeritaCard extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final String judul;
  final String tanggal;
  final String publisher;
  final String durasiBaca;

  const BeritaCard({
    super.key,
    this.width = 167,
    this.height = 170,
    required this.imageUrl,
    this.judul = " ",
    required this.tanggal,
    required this.publisher,
    required this.durasiBaca,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          SizedBox(
            width: 163,
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: MediaQuery.of(context).size.width * 0.031),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  publisher,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
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
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReadingBloc(ReadingService())..add(LoadLastRead()),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    print("Current User: $user");
    context.read<AuthBloc>().add(CekAuth());
    context.read<TicketBloc>().add(LoadTicket());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      transform: GradientRotation(120),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
                      stops: [0.0, 3],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/pattern.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            Spacer(flex: 98),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                right: 21,
                                left: 21,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          if (state is Authenticated) {
                                            return Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 24.22,
                                                  backgroundColor: Colors.blue,
                                                  backgroundImage:
                                                      state.avatarUrl != null
                                                      ? NetworkImage(
                                                          state.avatarUrl!,
                                                        )
                                                      : null,
                                                  child: state.avatarUrl == null
                                                      ? Text(
                                                          state.username[0]
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : null,
                                                ),

                                                SizedBox(width: 15),
                                                Text(
                                                  "Hai, ${state.username}!",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Text("Halo...");
                                        },
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showXpDialog(context);
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/coin.svg',
                                          width: 32,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const ChatHistoryPage(),
                                            ),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/chat-bubble.svg',
                                          width: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 21.0,
                                left: 21.0,
                                right: 21.0,
                                bottom: 21,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFAFAFA),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) => const SearchPage(),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    const begin = Offset(0, 1);
                                                    const end = Offset.zero;
                                                    const curve = Curves.ease;

                                                    final tween =
                                                        Tween(
                                                          begin: begin,
                                                          end: end,
                                                        ).chain(
                                                          CurveTween(
                                                            curve: curve,
                                                          ),
                                                        );
                                                    return SlideTransition(
                                                      position: animation.drive(
                                                        tween,
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                            ),
                                          );
                                        },
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText: "Cari ...",
                                          hintStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 14,
                                          ),
                                          suffixIcon: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Image.asset(
                                              "assets/search.png",
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => const SearchPage(),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  const begin = Offset(0, 1);
                                                  const end = Offset.zero;
                                                  const curve = Curves.ease;

                                                  final tween =
                                                      Tween(
                                                        begin: begin,
                                                        end: end,
                                                      ).chain(
                                                        CurveTween(
                                                          curve: curve,
                                                        ),
                                                      );
                                                  return SlideTransition(
                                                    position: animation.drive(
                                                      tween,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          "assets/filter.svg",
                                          width: 42,
                                          height: 42,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        //infoshape
                        height: MediaQuery.of(context).size.height * 0.073,
                        decoration: BoxDecoration(
                          color: Color(0XFFFEF6F6),
                          border: Border.all(
                            width: 0.5,
                            color: Color(0XFF946363),
                          ),
                          borderRadius: BorderRadius.circular(8.07),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.76),
                          child: Row(
                            spacing: 10.76,

                            children: [
                              SvgPicture.asset('assets/multiple-pages.svg'),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocBuilder<TicketBloc, TicketState>(
                                    builder: (context, state) {
                                      if (state is TicketLoaded) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tiket bacamu tersisa ${state.ticket}',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff131927),
                                                fontSize: 14,
                                              ),
                                            ),

                                            Text(
                                              'Tutup',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                  255,
                                                  137,
                                                  137,
                                                  137,
                                                ),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      if (state is TicketLoading) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [Text("Memuat tiket...")],
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tiket bacamu tersisa 0"),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: SvgPicture.asset("assets/wave1.svg", height: 52),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset("assets/wave2.svg", width: 147),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lanjutkan membaca',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          LihatSemuaText(
                            onTap: () {
                              Navigator.pushNamed(context, '/lanjutkanbaca');
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      BlocBuilder<ReadingBloc, ReadingState>(
                        builder: (context, state) {
                          if (state is ReadingLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is ReadingEmpty) {
                            return const Text(
                              "Belum ada materi yang dibaca",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF898989),
                              ),
                            );
                          }

                          if (state is ReadingLoaded) {
                            final list = state.materiList;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(list.length * 2 - 1, (
                                index,
                              ) {
                                if (index.isEven) {
                                  final materi = list[index ~/ 2];

                                  return MateriCard(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.43,
                                    height: 223,
                                    imageUrl: materi['cover_url'] ?? "",
                                    kategori: materi['kategori'] ?? "Materi",
                                    materi: materi['materi'] ?? "",
                                    judul: materi['judul'] ?? "",
                                    sumber: materi['sumber'] ?? "",
                                  );
                                }
                                return const Spacer();
                              }),
                            );
                          }
                          if (state is ReadingError) {
                            return Text(state.message);
                          }

                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    //Inspirasi section
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Inspirasi',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: colors.blue,
                              fontSize: 16,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          LihatSemuaText(
                            onTap: () {
                              Navigator.pushNamed(context, '/inspirasi');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      FutureBuilder(
                        future: InspirasiService().getRandomInspirasi(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          final inspirasiList = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: inspirasiList.map<Widget>((item) {
                              return InspirasiCard(
                                imageUrl: item['photo_url'],
                                nama: item['nama'],
                                deskripsi: item['profesi'],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    //Berita section
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Berita terkini',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: colors.blue,
                              fontSize: 16,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          LihatSemuaText(
                            onTap: () {
                              Navigator.pushNamed(context, '/berita');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      FutureBuilder(
                        future: BeritaService().getBerita(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final beritaList = snapshot.data!;

                          return Column(
                            spacing: 16,
                            children: beritaList.map<Widget>((item) {
                              return BeritaCard(
                                imageUrl: item['photo_url'],
                                judul: item['judul'],
                                tanggal: formatTanggal(item['date']),
                                publisher: item['sumber'],
                                durasiBaca: "5 menit dibaca",
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ], //Listview children
        ),
      ),
    );
  }
}
