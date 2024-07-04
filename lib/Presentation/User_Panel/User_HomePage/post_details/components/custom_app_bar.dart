import 'package:flutter/material.dart';

import '../../../../../Widgets/styles.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
      ),
      child: SizedBox(
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
