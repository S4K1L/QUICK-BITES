import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: Container(
        height: 80,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFFCA6CE5),
              ),
              child: TextButton(
                onPressed: onPress,
                child: Text(
                  text,
                  style:  GoogleFonts.adamina(
                    textStyle: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

