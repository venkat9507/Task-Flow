import 'dart:math';
import 'package:flutter/material.dart';

/// Confetti celebration widget
class ConfettiCelebration extends StatefulWidget {
  final Widget child;
  final bool celebrate;
  final VoidCallback? onComplete;

  const ConfettiCelebration({
    super.key,
    required this.child,
    this.celebrate = false,
    this.onComplete,
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Confetti>? _confetti;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _confetti = List.generate(50, (index) => Confetti.random(_random));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_confetti != null)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: ConfettiPainter(
                  confetti: _confetti!,
                  progress: _controller.value,
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Individual confetti piece
class Confetti {
  final double x;
  final double startY;
  final double size;
  final Color color;
  final double rotation;
  final double speed;

  Confetti({
    required this.x,
    required this.startY,
    required this.size,
    required this.color,
    required this.rotation,
    required this.speed,
  });

  factory Confetti.random(Random random) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];

    return Confetti(
      x: random.nextDouble(),
      startY: random.nextDouble() * -0.5,
      size: random.nextDouble() * 8 + 4,
      color: colors[random.nextInt(colors.length)],
      rotation: random.nextDouble() * 2 * pi,
      speed: random.nextDouble() * 0.5 + 0.5,
    );
  }
}

/// Confetti painter
class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in confetti) {
      final paint = Paint()
        ..color = piece.color.withValues(alpha: 1 - progress)
        ..style = PaintingStyle.fill;

      final x = piece.x * size.width;
      final y = (piece.startY + progress * piece.speed * 1.5) * size.height;
      final rotation = piece.rotation + progress * 4;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw confetti piece (rectangle)
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 1.5,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// Extension to easily add confetti to any widget
extension ConfettiExtension on Widget {
  Widget withConfetti({required bool celebrate, VoidCallback? onComplete}) {
    return ConfettiCelebration(
      celebrate: celebrate,
      onComplete: onComplete,
      child: this,
    );
  }
}
