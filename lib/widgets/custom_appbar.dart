import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dynamicLeadingWidth = screenWidth * 0.13;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: dynamicLeadingWidth,
      leading: Container(
        margin: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }
}
