import 'package:flutter/material.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Homepeg lom jadi, harap dipercepat yh", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),)
        ],
      ),
    );
  }
}
