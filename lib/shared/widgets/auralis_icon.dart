import 'package:flutter/material.dart';
import 'package:music_app/core/constants/app_colors.dart';

class AuralisLogo extends StatelessWidget {
  final double size;
  final bool animate;

  const AuralisLogo({
    super.key,
    this.size = 48,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AuralisLogoPainter(),
      ),
    );
  }
}

class _AuralisLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..shader = AppColors.cyanVioletGradient.createShader(
        Rect.fromLTWH(0, 0, w, h),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Geometric "A" with stylized sound-frequency pinnacle
    path.moveTo(w * 0.18, h * 0.85);
    path.lineTo(w * 0.5, h * 0.12);
    path.lineTo(w * 0.82, h * 0.85);

    // Inner frequency cross-bridge
    path.moveTo(w * 0.32, h * 0.62);
    path.lineTo(w * 0.44, h * 0.55);
    path.lineTo(w * 0.56, h * 0.68);
    path.lineTo(w * 0.68, h * 0.62);

    // Subtle glow back shadow
    final glowPaint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
