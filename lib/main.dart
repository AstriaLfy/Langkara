import 'package:flutter/material.dart';
import 'package:langkara/Pages/on_boarding_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://exdtkmfhqtgewykwvgmc.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4ZHRrbWZocXRnZXd5a3d2Z21jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3NDAzNTMsImV4cCI6MjA4NzMxNjM1M30.pMTAsc-bA0pgD8im63JSTwu50mAkOW9DH-eNzPklgmc",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSans3TextTheme(Theme.of(context).textTheme,),),
      home: OnBoardingPage(),
    );
  }
}