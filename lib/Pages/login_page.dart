import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';import 'package:http/http.dart' as http;
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Pages/Widgets/text_field.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/Pages/navigation_menu.dart';
import 'package:langkara/Pages/register_page.dart';
import 'package:langkara/Pages/Widgets/button_google.dart';
import 'package:langkara/const/colors.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  bool _showpw = true;
  String? emailError;
  String? pwError;
  bool RememberCheck = false;

  testing() {
    print("test");
    print(emailController.text);
    print(pwController.text);
  }


  @override
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<AuthBloc>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            print("Move to Navigation Page");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationMenu()),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Username or Password Wrong!")),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 88),
                 SvgPicture.asset("assets/Logo_Text.svg"),
              
                  const SizedBox(height: 8),
                  Text(
                    "Selamat datang kembali!\nSenang bertemu Anda lagi!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: colors.blue,),
                  ),
                  const SizedBox(height: 10),
              
                  NormalField(
                    controller: emailController,
                    labelText: "Email",
                    hintText: "Input your Email here",
                    errorText: emailError,
                  ),
              
                  //pw field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: pwController,
                      obscureText: _showpw,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Input Your Password here",
                        errorText: pwError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _showpw = !_showpw),
                          icon: Icon(
                            _showpw ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: RememberCheck,
                            onChanged: (bool? value) {
                              setState(() {
                                RememberCheck = value ?? false;
                              });
                              print("Status Remember Me: $RememberCheck");
                            },
                          ),
                          const Text("Remember me"),
                        ],
                      ),
              
                      GestureDetector(
                        onTap: () {
                          print("forgot pw test");
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
              
                  const SizedBox(height: 10),
                  primaryButton(
                    text: "Login",
                    onPressed: () {
                      setState(() {
                        emailError = emailController.text.isEmpty
                            ? "Email cannot be empty"
                            : (!emailController.text.contains('@')
                                  ? "Invalid email format"
                                  : null);
                        pwError = pwController.text.isEmpty
                            ? "Password cannot be empty"
                            : null;
              
                        if (emailError == null && pwError == null) {
                          loginBloc.add(
                            LoginSubmited(
                              emailController.text,
                              pwController.text,
                            ),
                          );
                        }
                      });
                    },
                    foregroundColor: Colors.white,
                  ),
              
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1, color: Colors.black,)),
              
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("or", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(child: Divider(thickness: 1,color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 5),
              
                  googleButton(
                    text: "Login with Google",
                    onPressed: () {
                      print("login google");
                      loginBloc.add(GoogleSignInRequest());
                    },
                    foregroundColor: const Color(0xFF1A2A4F),
                  ),
              
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun? "),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const registerPage(),
                          ),
                        ),
                        child: const Text(
                          " Daftar disini",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
