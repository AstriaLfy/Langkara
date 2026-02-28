import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Pages/welcome_page.dart';
import 'package:langkara/Repository/auth_repository.dart';
import 'package:langkara/Services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://exdtkmfhqtgewykwvgmc.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4ZHRrbWZocXRnZXd5a3d2Z21jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3NDAzNTMsImV4cCI6MjA4NzMxNjM1M30.pMTAsc-bA0pgD8im63JSTwu50mAkOW9DH-eNzPklgmc",
  );

  final authService = AuthService();
  final authRepository = AuthRepository(authService);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(authRepository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}