import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/const/colors.dart';
import 'package:langkara/Pages/register_page.dart';
import 'package:langkara/Pages/login_page.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/Logo_Text.svg"),

              Column(
                spacing: 20,
                children: [
                  Text(
                    "Selamat Datang di\nLangkara!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Aplikasi andalan yang akan\nmembantu kebutuhan Anda\nkapan saja.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: colors.blue),
                  ),
                ],
              ),

              SizedBox(height: 40,),

              Column(
                children: [
                  primaryButton(
                    text: "Masuk",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const loginPage(),));
                    },
                    foregroundColor: Colors.white,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.black),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "atau",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  primaryButton(
                    text: "Daftar",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const registerPage(),));
                    },
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
