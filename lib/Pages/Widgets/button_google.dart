import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langkara/const/colors.dart';

class googleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color foregroundColor;

  const googleButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: 366,
      height: 45,
      decoration: BoxDecoration(
        color: colors.blue,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFF1A2A4F),
              width: 1
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: colors.blue,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(width: 10,),
            SvgPicture.asset("assets/googleLogo.svg", width: 20, height: 20,)
          ],
        ),
      ),
    );
  }
}