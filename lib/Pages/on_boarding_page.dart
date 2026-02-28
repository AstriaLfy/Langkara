import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    print("Supabase URL: ${supabase.rest.url}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Check console"),
      ),
    );
  }
}