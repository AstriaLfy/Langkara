import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Auth/auth_bloc.dart';
import 'package:langkara/Pages/Widgets/button_google.dart';
import 'package:langkara/Pages/Widgets/text_field.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/Pages/login_page.dart';
import 'package:langkara/Pages/navigation_menu.dart';

final List<String> avatars = [
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar1.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjEucG5nIiwiaWF0IjoxNzczMzcyMDIwLCJleHAiOjE4MDQ5MDgwMjB9.pLdKhxnv0ZhETYCfPXPpP7kX8mc9tMMPdUPOxEWKGOs",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar2.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjIucG5nIiwiaWF0IjoxNzczMzcyMDQ5LCJleHAiOjE4MDQ5MDgwNDl9.7q1pFaBTIf3YIlVdqnAUELjAT5uEx2S6CTGQVx6mo3c",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar3.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjMucG5nIiwiaWF0IjoxNzczMzcyMDY1LCJleHAiOjE4MDQ5MDgwNjV9.I-ggD8WtZj7NFwkQZk6bZtOJ9Clc-H89iac98xv4ups",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar4.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjQucG5nIiwiaWF0IjoxNzczMzcyNjc0LCJleHAiOjE4MDQ5MDg2NzR9.kGTdbLKdkBNS7f4zLmJ4wsX_UW3ktqi07KZDxdyM0sM",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar5.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjUucG5nIiwiaWF0IjoxNzczMzcyMDk1LCJleHAiOjE4MDQ5MDgwOTV9.aKmUoMd5BNICw7HfiT-sEieWaXd2NqBKw397kd86PcU",
  "https://exdtkmfhqtgewykwvgmc.supabase.co/storage/v1/object/sign/avatars/avatar6.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83N2VjZTdjZS1jYjk4LTQwNWItOTFlMi1jYjI0ZmQxOWQ5YWYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL2F2YXRhcjYucG5nIiwiaWF0IjoxNzczMzcyMTE0LCJleHAiOjE4MDQ5MDgxMTR9.UuUtu4piTN3nuiJHMlGUlc-xlDq_RobB6LOH0rWuNUUg",
];

Future<String?> showAvatarPicker(BuildContext context) {
  int selectedIndex = -1;

  return showGeneralDialog<String>(
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
                      onPressed: () {
                        if (selectedIndex == -1) return;

                        final selectedAvatar = avatars[selectedIndex];

                        Navigator.pop(context, selectedAvatar);
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
    },
  );
}

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  String? selectedAvatar;
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
                  SizedBox(height: 30),
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

                  Center(
                    child: Stack(
                      children: [
                        Container(
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: selectedAvatar != null
                                ? NetworkImage(selectedAvatar!)
                                : null,
                            child: selectedAvatar == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),

                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final avatar = await showAvatarPicker(context);

                                if (avatar != null) {
                                  setState(() {
                                    selectedAvatar = avatar;
                                  });
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Ink(
                                height: 24,
                                width: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1A2A4F),
                                      Color(0xFFDD979B),
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
                  ),

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
                            _showConpw
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                              selectedAvatar,
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
