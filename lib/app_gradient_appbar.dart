import 'package:flutter/material.dart';

class AppGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppGradientAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: Color(0xFF3B0B4F)),
      ),
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
