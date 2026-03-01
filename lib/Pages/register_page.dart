import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Pages/Widgets/button_google.dart';
import 'package:langkara/Pages/Widgets/text_field.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/Pages/login_page.dart';
import 'package:langkara/Pages/navigation_menu.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPW = TextEditingController();
  final usnController = TextEditingController();
  bool _showpw = true;
  bool _showConpw = true;
  String? usnError;
  String? emailError;
  String? conPwError;
  String? pwError;
  String? selectedGender;

  testing() {
    print("test");
    print(emailController.text);
    print(pwController.text);
  }

  @override
  Widget build(BuildContext context) {
    final registerBloc = context.read<AuthBloc>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Register Succees")));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => loginPage()),
            );
          } else if (state is LoginSuccess) {
            print("Move to Navigation Page");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationMenu()),
            );
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.messege)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            print("Loading");
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Text(
                    "Selamat Datang!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mari kita buat akun Anda.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 30),

                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey,
                  ),

                  const SizedBox(height: 20),

                  NormalField(
                    controller: usnController,
                    labelText: "Username",
                    hintText: "Input your Email here",
                    errorText: usnError,
                  ),

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
                          onPressed: () {
                            setState(() {
                              _showpw = !_showpw;
                            });
                          },
                          icon: Icon(
                            _showpw ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //confirm pw field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: confirmPW,
                      obscureText: _showConpw,
                      decoration: InputDecoration(
                        labelText: "confirm password",
                        hintText: "Input Your Password here",
                        errorText: conPwError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showConpw = !_showConpw;
                            });
                          },
                          icon: Icon(
                            _showConpw ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        spacing: 30,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Laki-laki",
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              const Text("Laki-laki"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: "Perempuan",
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              const Text("Perempuan"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  primaryButton(
                    text: "Sign up",
                    onPressed: () {
                      setState(() {
                        if (usnController.text.isEmpty) {
                          usnError = "Username cannot be empty";
                        } else {
                          usnError = null;
                        }

                        if (emailController.text.isEmpty) {
                          emailError = "Email cannot be empty";
                        } else if (!emailController.text.contains('@')) {
                          emailError = "Incorrect email format";
                        } else {
                          emailError = null;
                        }

                        if (pwController.text.isEmpty) {
                          pwError = "Password cannot be empty";
                        } else if (pwController.text.length < 8) {
                          pwError =
                              "Password must be at least 8 characters long";
                        } else {
                          pwError = null;
                        }

                        if (confirmPW.text.isEmpty) {
                          conPwError = "Password cannot be empty";
                        } else if (confirmPW.text.length < 8) {
                          conPwError =
                              "Password must be at least 8 characters long";
                        } else if (confirmPW.text != pwController.text) {
                          conPwError = "Password do not match";
                        } else {
                          pwError = null;
                        }

                        if (usnError == null &&
                            emailError == null &&
                            pwError == null &&
                            emailController.text.isNotEmpty &&
                            pwController.text.isNotEmpty) {
                          print("Register Acc");
                          registerBloc.add(
                            RegisterSubmited(
                              emailController.text,
                              pwController.text,
                              usnController.text,
                            ),
                          );
                        }
                      });
                    },
                    foregroundColor: Colors.white,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(thickness: 2, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "atau",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 2, color: Colors.grey),
                      ),
                    ],
                  ),

                  googleButton(
                    text: "Sign up with Google",
                    onPressed: () {
                      print("login google");
                      registerBloc.add(GoogleSignInRequest());
                    },
                    foregroundColor: Color(0x1A2A4F),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginPage(),
                          ),
                        ),
                        child: Text(
                          " Login here",
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