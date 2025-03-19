import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
      final dynamicLeadingWidth = screenWidth * 0.13;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: dynamicLeadingWidth,
      leading:  Container(
        margin: EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
