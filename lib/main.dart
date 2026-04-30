import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langkara/Pages/login_page.dart';
import 'package:langkara/Pages/navigation_menu.dart';
import 'package:langkara/Pages/profile_page.dart';
import 'package:langkara/pages/on_boarding_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/Bloc/Ticket/ticket_bloc.dart';
import 'package:langkara/Bloc/reading/reading_bloc.dart';
import 'package:langkara/Services/reading_service.dart';
import 'package:langkara/Services/profile_services.dart';
import 'package:langkara/Bloc/search/search_bloc.dart';
import 'package:langkara/Services/search_service.dart';
import 'package:langkara/Bloc/Profile_tab/profile_materi_bloc.dart';
import 'package:langkara/Services/profile_tab_services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/Repository/auth_repository.dart';
import 'package:langkara/repository/materi_repository.dart';
import 'package:langkara/Services/auth_services.dart';
import 'package:langkara/services/materi_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;
  final session = Supabase.instance.client.auth.currentSession;
  final isLoggedIn = rememberMe && session != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(AuthService()),
        ),
        RepositoryProvider(
          create: (context) => MateriRepository(MateriService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => MateriBloc(
              context.read<MateriRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.montserratTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          ),
          home: isLoggedIn ? NavigationMenu() : const OnboardingPage(),
        ),
      ),
    );
  }
}
