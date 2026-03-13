import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Pages/login_page.dart';
import 'package:langkara/Bloc/profile_tab/profile_achievement_bloc.dart';
import 'package:langkara/Bloc/profile_tab/profile_materi_bloc.dart';
import 'package:langkara/Bloc/profile_tab/profile_bookmark_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:langkara/Services/profile_services.dart';
import 'package:langkara/const/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;


void showXpDialog(BuildContext context) async {
  final profileService = ProfileService();

  final profile = await profileService.getCurrentUserProfile();
  final int xp = profile['xp'] ?? 0;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: const Color(0xffEDEDED),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Total XP Kamu",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.monetization_on,
                    color: Color(0xffF2B705),
                    size: 32,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "$xp",
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                "XP diperoleh dari aktivitas belajar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: "Montserrat",
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 45,
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1A2A4F),
                          Color(0xffDD979B),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Tutup",
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
        ),
      );
    },
  );
}

final List<String> avatars = [
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar1.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjEucG5nIiwiaWF0IjoxNzczMzcyMDIwLCJleHAiOjE4MDQ5MDgwMjB9.pLdKhxnv0ZhETYCfPXPpP7kX8mc9tMMPdUPOxEWKGOs",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar2.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjIucG5nIiwiaWF0IjoxNzczMzcyMDQ5LCJleHAiOjE4MDQ5MDgwNDl9.7q1pFaBTIf3YIlVdqnAUELjAT5uEx2S6CTGQVx6mo3c",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar3.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjMucG5nIiwiaWF0IjoxNzczMzcyMDY1LCJleHAiOjE4MDQ5MDgwNjV9.I-ggD8WtZj7NFwkQZk6bZtOJ9Clc-H89iac98xv4ups",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar4.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjQucG5nIiwiaWF0IjoxNzczMzcyNjc0LCJleHAiOjE4MDQ5MDg2NzR9.kGTdbLKdkBNS7f4zLmJ4wsX_UW3ktqi07KZDxdyM0sM",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar5.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjUucG5nIiwiaWF0IjoxNzczMzcyMDk1LCJleHAiOjE4MDQ5MDgwOTV9.aKmUoMd5BNICw7HfiT-sEieWaXd2NqBKw397kd86PcU",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar6.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjYucG5nIiwiaWF0IjoxNzczMzcyMTE0LCJleHAiOjE4MDQ5MDgxMTR9.UuUtu4piTN3nuiJHMlGUlc-xlDq_RobB6LOH0rWuNUUg",
];
void showAvatarPicker(BuildContext context) {
  int selectedIndex = -1;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xffEDEDED),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: avatars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xff1A2A4F)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatars[index]),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: 160,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedIndex == -1) return;

                        final selectedAvatar = avatars[selectedIndex];

                        context.read<AuthBloc>().add(
                          UpdateAvatarEvent(selectedAvatar),
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Ink(
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Color(0xff1A2A4F), Color(0xffDD979B)],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Pilih",
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
            ),
          );
        },
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
    }
  );
}

Future<void> logout(BuildContext context) async {
  await Supabase.instance.client.auth.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => loginPage()),
    (route) => false,
  );
}

void showProfileUpdatedDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (context, animation, secondaryAnimation) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xffEDEDED),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profil berhasil diperbarui!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Data profil Anda sudah berhasil disimpan. "
                "Pastikan informasi yang Anda isi sudah benar agar "
                "pengalaman penggunaan aplikasi menjadi lebih optimal.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: "Montserrat",
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 45,
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
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
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      );
    },
  );
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}

class FAQSection {
  final String title;
  final List<FAQItem> items;

  FAQSection(this.title, this.items);
}

final List<FAQSection> faqData = [
  FAQSection("Akun & Registrasi", [
    FAQItem(
      "1. Apakah laki-laki bisa menggunakan LANGKARA?",
      "LANGKARA berfokus pada pemberdayaan perempuan di STEM."
          "Pengguna laki-laki dapat mengakses sebagian fitur, namun beberapa interaksi tertentu dibatasi untuk menjaga ruang yang aman bagi perempuan.",
    ),

    FAQItem(
      "2. Apakah saya harus berasal dari jurusan STEM untuk menggunakan LANGKARA?",
      "Ya, saat ini LANGKARA dirancang khusus untuk mahasiswa yang "
          "memiliki minat atau latar belakang di bidang STEM.",
    ),
    FAQItem(
      "3. Bagaimana jika saya lupa password akun saya?",
      "Pengguna dapat menggunakan fitur “Lupa Password” pada "
          "halaman login untuk mengatur ulang password melalui email.",
    ),
  ]),

  FAQSection("Materiku", [
    FAQItem(
      "1. Apa itu fitur Materiku?",
      "Materiku adalah fitur yang menyediakan rangkuman materi STEM "
          "dalam bentuk slide carousel yang ringkas dan visual hingga lebih mudah dipahami.",
    ),

    FAQItem(
      "2. Apakah semua materi di LANGKARA gratis?",
      "Sebagian besar materi dapat diakses secara gratis. "
          "Beberapa materi mungkin memerlukan tiket baca atau fitur premium.",
    ),
  ]),

  FAQSection("Temanku", [
    FAQItem(
      "1. Apa itu fitur Temanku?",
      "Temanku adalah fitur untuk menemukan partner lomba atau tim proyek "
          "berdasarkan skill dan level proyek.",
    ),

    FAQItem(
      "2. Bagaimana cara bergabung dalam sebuah proyek?",
      "Pengguna dapat memilih proyek yang tersedia lalu menekan tombol 'Kirim Pesan'.",
    ),

    FAQItem(
      "3. Mengapa saya tidak bisa memulai chat dengan pengguna lain?",
      "Untuk menjaga kenyamanan pengguna perempuan, sistem membatasi interaksi tertentu.",
    ),
  ]),

  FAQSection("XP dan Aktivitas Pengguna", [
    FAQItem(
      "1. Apa manfaat XP?",
      "XP dapat digunakan untuk membuka materi tambahan selain dengan tiket baca harian.",
    ),
  ]),

  FAQSection("Keamanan", [
    FAQItem(
      "1. Bagaimana jika saya menemukan konten yang tidak sesuai?",
      "Pengguna dapat melaporkan konten melalui fitur 'Laporkan'.",
    ),
  ]),

  FAQSection("Bantuan", [
    FAQItem(
      "1. Aplikasi saya tidak bisa dibuka, apa yang harus saya lakukan?",
      "Coba tutup aplikasi dan buka kembali. Jika masalah tetap terjadi, "
          "periksa koneksi internet atau perbarui aplikasi.",
    ),
  ]),
];
Widget faqQuestion(String question, String answer) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: "Montserrat",
          fontSize: 13,
          color: Colors.black,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: "$question\n",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          TextSpan(
            text: answer,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget faqItem({required String title, required List<Widget> children}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xff4A5A7A)),
    ),
    child: ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Montserrat",
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      childrenPadding: const EdgeInsets.all(16),
      children: children,
    ),
  );
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        toolbarHeight: 123,
        title: const Text(
          "FAQ & Bantuan",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
      ),

      body: ListView(
        children: faqData.map((section) {
          return faqItem(
            title: section.title,
            children: section.items
                .map((item) => faqQuestion(item.question, item.answer))
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}

void showChangePasswordPopup(BuildContext context) {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final client = supabase.Supabase.instance.client;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 330,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Kata Sandi Baru",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: confirmController,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Ulang Kata Sandi Baru",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 45,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      final newPassword = passwordController.text;

                      if (newPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password tidak boleh kosong"),
                          ),
                        );
                        return;
                      }

                      try {
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(password: newPassword),
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password berhasil diubah"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
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
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool hasChanged = false;
  String initialName = "";
  String initialUsername = "";
  String initialJurusan = "";
  String initialUniversitas = "";
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final jurusanController = TextEditingController();
  final universitasController = TextEditingController();
  final kemampuanController = TextEditingController();

  String? gender;
  @override
  void initState() {
    super.initState();

    final state = context.read<AuthBloc>().state;

    if (state is Authenticated) {
      initialUsername = state.username;
      initialJurusan = state.jurusan ?? "";
      initialUniversitas = state.universitas ?? "";

      nameController.text = initialName;
      usernameController.text = initialUsername;
      jurusanController.text = initialJurusan;
      universitasController.text = initialUniversitas;
    }

    nameController.addListener(checkChanges);
    usernameController.addListener(checkChanges);
    jurusanController.addListener(checkChanges);
    universitasController.addListener(checkChanges);
  }

  void checkChanges() {
    final changed =
        nameController.text != initialName ||
        usernameController.text != initialUsername ||
        jurusanController.text != initialJurusan ||
        universitasController.text != initialUniversitas;

    if (changed != hasChanged) {
      setState(() {
        hasChanged = changed;
      });
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xffC9D2E3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xffC9D2E3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xff5B7BFE)),
      ),
    );
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        UpdateProfile(
          nama: nameController.text,
          username: usernameController.text,
          email: emailController.text,
          jurusan: jurusanController.text,
          universitas: universitasController.text,
          gender: gender ?? "",
          kemampuan: kemampuanController.text,
        ),
      );
      showProfileUpdatedDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        toolbarHeight: 123,
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Nama",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: inputDecoration("Nama"),
              ),

              const SizedBox(height: 16),

              const Text(
                "Username",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                decoration: inputDecoration("Username"),
              ),

              const SizedBox(height: 16),

              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: inputDecoration("Email").copyWith(
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: SvgPicture.asset(
                      "assets/mail.svg",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Jurusan",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: jurusanController,
                decoration: inputDecoration("Jurusan"),
              ),

              const SizedBox(height: 16),

              const Text(
                "Universitas",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: universitasController,
                decoration: inputDecoration("Universitas"),
              ),

              const SizedBox(height: 16),

              const Text(
                "Gender",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                          value: "Perempuan",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text("Perempuan"),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                          value: "Laki-laki",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text("Laki-laki"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Kemampuan",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: kemampuanController,
                decoration: inputDecoration("Kemampuan"),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: hasChanged ? saveProfile : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: hasChanged
                            ? const [Color(0xff2E335A), Color(0xffD78A8A)]
                            : const [Colors.grey, Colors.grey],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Widget editPage;

  @override
  void initState() {
    super.initState();
    editPage = const EditProfilePage();
  }

  Widget buildMenuItem(String title, {Color? color, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: color ?? Color(0xff151515),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Divider(height: 1),
        ),
      ],
    );
  }

  Widget buildMenuItem1(String title, {Color? color, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: color ?? Color(0xff151515),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ],
    );
  }

  Widget buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        toolbarHeight: 123,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            color: Color(0xff151515),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            buildCard([
              buildMenuItem(
                "Edit Profil",
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const EditProfilePage(),
                      transitionDuration: const Duration(milliseconds: 200),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              buildMenuItem1(
                "Ubah Kata Sandi",
                onTap: () {
                  showChangePasswordPopup(context);
                },
              ),
            ]),
            buildCard([
              buildMenuItem("Notifikasi"),
              buildMenuItem("Pencapaian"),
              buildMenuItem("Bahasa"),
              buildMenuItem("Privasi & Keamanan"),
              buildMenuItem(
                "FAQ & Bantuan",
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const FAQPage(),
                      transitionDuration: const Duration(milliseconds: 200),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              buildMenuItem(
                "Keluar",
                color: Colors.red,
                onTap: () {
                  logout(context);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

double calculateProfileProgress(Authenticated state) {
  int completed = 0;
  int total = 5;

  if (state.username.trim().isNotEmpty) completed++;
  if (state.gmail.trim().isNotEmpty) completed++;
  if (state.avatarUrl != null && state.avatarUrl!.isNotEmpty) completed++;
  if (state.jurusan != null && state.jurusan!.isNotEmpty) completed++;
  if (state.universitas != null && state.universitas!.isNotEmpty) completed++;
  // if (state.nama != null && state.nama!.isNotEmpty) completed++;
  // if (state.gender != null && state.gender!.isNotEmpty) completed++;
  // if (state.kemampuan != null && state.kemampuan!.isNotEmpty) completed++;

  return completed / total;
}

class ProfileMateriTab extends StatelessWidget {
  const ProfileMateriTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileMateriBloc, ProfileMateriState>(
      builder: (context, state) {
        if (state is ProfileMateriLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileMateriEmpty) {
          return const Center(
            child: Text(
              "Belum ada materi",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
            ),
          );
        }

        if (state is ProfileMateriLoaded) {
          final materi = state.materi;

          return GridView.builder(
            itemCount: materi.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final item = materi[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      print(item['judul']);
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item['cover_url'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 12,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MATERI :",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: Color(0xFFFAFAFA),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['judul'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class ProfileAchievementTab extends StatelessWidget {
  const ProfileAchievementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileAchievementBloc, ProfileAchievementState>(
      builder: (context, state) {
        if (state is ProfileAchievementLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileAchievementEmpty) {
          return const Center(
            child: Text(
              "Belum ada Achievement",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
            ),
          );
        }

        if (state is ProfileAchievementLoaded) {
          final achievement = state.achievement;

          return GridView.builder(
            itemCount: achievement.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 1.529,
            ),
            itemBuilder: (context, index) {
              final item = achievement[index];

              return ClipRRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        item['certificate_image_url'] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class ProfileBookmarkTab extends StatelessWidget {
  const ProfileBookmarkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBookmarkBloc, ProfileBookmarkState>(
      builder: (context, state) {
        if (state is ProfileBookmarkLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileBookmarkEmpty) {
          return const Center(
            child: Text(
              "Belum ada Bookmark",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
            ),
          );
        }

        if (state is ProfileBookmarkLoaded) {
          final bookmark = state.bookmark;

          return GridView.builder(
            itemCount: bookmark.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final item = bookmark[index];

              return ClipRRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        item['cover_url'] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 12,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MATERI :",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFFFAFAFA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['judul'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

//progress bar
class ProfileProgressBar extends StatelessWidget {
  final double progress;

  const ProfileProgressBar({super.key, required this.progress});
  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final progressWidth = barWidth * progress;

        return Container(
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff563A3A), width: 0.5),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: progressWidth,
                decoration: BoxDecoration(
                  color: const Color(0xffF7A5A5),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Center(
                child: Text(
                  "$percent%",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: progress > 0.5 ? Color(0xffFAFAFA) : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//try@gmail.com
//try12345
class _ProfilePageState extends State<ProfilePage> {
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
                  height: MediaQuery.of(context).size.height * 0.13,
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
                          'assets/patternProfile.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        right: 20,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingPage(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                "assets/settings.svg",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 0,
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is Authenticated) {
                                double progress = calculateProfileProgress(
                                  state,
                                );
                                return Column(
                                  children: [
                                    Row(
                                      spacing: 20,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(
                                                2.5,
                                              ),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffF7A5A5),
                                              ),
                                              child: CircleAvatar(
                                                radius: 35.15,
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
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 2,
                                              right: 2,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    showAvatarPicker(context);
                                                  },
                                                  customBorder:
                                                      const CircleBorder(),
                                                  child: Ink(
                                                    height: 24,
                                                    width: 24,
                                                    decoration:
                                                        const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                colors: [
                                                                  Color(
                                                                    0xFF1A2A4F,
                                                                  ),
                                                                  Color(
                                                                    0xFFDD979B,
                                                                  ),
                                                                ],
                                                              ),
                                                        ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.username,
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                                fontSize: 16,
                                              ),
                                            ),

                                            Text(
                                              state.jurusan ?? "Jurusan",
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                              ),
                                            ),

                                            Text(
                                              state.universitas ??
                                                  "Universitas",
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Sempurnakan identitasmu!",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        ProfileProgressBar(progress: progress),

                                        const SizedBox(height: 16),
                                        Container(
                                          width: 168,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF7A5A5),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 2,
                                                spreadRadius: 0,
                                                color: Color.fromARGB(
                                                  64,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                        const EditProfilePage(),
                                                    transitionDuration:
                                                        const Duration(
                                                          milliseconds: 200,
                                                        ),
                                                    transitionsBuilder:
                                                        (
                                                          _,
                                                          animation,
                                                          __,
                                                          child,
                                                        ) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                  ),
                                                );
                                              },
                                              child: const SizedBox.expand(
                                                child: Center(
                                                  child: Text(
                                                    "Edit profil",
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xffFAFAFA),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 17),
                    DefaultTabController(
                      length: 3,
                      child: Builder(
                        builder: (context) {
                          final controller = DefaultTabController.of(context);

                          return Column(
                            children: [
                              AnimatedBuilder(
                                animation: controller,
                                builder: (context, _) {
                                  return TabBar(
                                    indicatorColor: colors.blue,
                                    indicatorWeight: 2,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: [
                                      Tab(
                                        child: SvgPicture.asset(
                                          controller.index == 0
                                              ? "assets/materi_active.svg"
                                              : "assets/materi.svg",
                                        ),
                                      ),
                                      Tab(
                                        child: SvgPicture.asset(
                                          controller.index == 1
                                              ? "assets/achievement_active.svg"
                                              : "assets/achievement.svg",
                                        ),
                                      ),
                                      Tab(
                                        child: SvgPicture.asset(
                                          controller.index == 2
                                              ? "assets/bookmark_active.svg"
                                              : "assets/bookmark.svg",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 2),

                              SizedBox(
                                height: 400,
                                child: const TabBarView(
                                  children: [
                                    ProfileMateriTab(),
                                    ProfileAchievementTab(),
                                    ProfileBookmarkTab(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
