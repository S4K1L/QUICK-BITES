import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bites/Theme/constant.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const OptionButton({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Container(
            height: 70,
            width: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: 60,
                width: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFCA6CE5),
                ),
                child: TextButton(
                  onPressed: onPress,
                  child: Text(
                    text,
                    style: GoogleFonts.adamina(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/love.png',
              width: 30,
              height: 30,
              color: sWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
