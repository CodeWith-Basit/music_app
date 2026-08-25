import 'dart:math';
import 'package:flutter/material.dart';

class EqualizerAnimation extends StatefulWidget {
  final Color color;
  final double height;
  final double barWidth;

  const EqualizerAnimation({
    super.key,
    this.color = const Color(0xFFDB2777),
    this.height = 20,
    this.barWidth = 3,
  });

  @override
  State<EqualizerAnimation> createState() => _EqualizerAnimationState();
}

class _EqualizerAnimationState extends State<EqualizerAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // 4 bars, each with a slightly different speed for a realistic look
    _controllers = List.generate(4, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + _random.nextInt(400)),
      )..repeat(reverse: true);
    });

    _animations = _controllers.map((controller) {
      final double minHeight = 0.25 + _random.nextDouble() * 0.15;
      return Tween<double>(begin: minHeight, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.barWidth * 4 + 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_animations.length, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: widget.barWidth,
                height: widget.height * _animations[index].value,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}