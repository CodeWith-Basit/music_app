import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const AppBackground({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          tileMode: TileMode.repeated,
          end: Alignment.topRight,
          colors: isDarkMode
              ? const [Color(0xFF3B0B4F), Color(0xFF181126), Color(0xFF0D0D1A)]
              : const [Color(0xFFE8C7F2), Color(0xFFF8F2FA), Colors.white],
        ),
      ),
      child: child,
    );
  }
}
