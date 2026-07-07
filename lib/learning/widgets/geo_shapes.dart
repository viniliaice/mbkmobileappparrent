import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/geo_shape.dart';

class ShapePainter extends CustomPainter {
  final GeoShape shape;
  final Color color;

  ShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final w = size.width, h = size.height;
    Path path = Path();

    switch (shape) {
      case GeoShape.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2.2, paint);
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2.2, stroke);
        return;
      case GeoShape.oval:
        final rect = Rect.fromCenter(center: Offset(w / 2, h / 2), width: w, height: h * 0.65);
        canvas.drawOval(rect, paint);
        canvas.drawOval(rect, stroke);
        return;
      case GeoShape.square:
        final side = w * 0.8;
        final rect = Rect.fromCenter(center: Offset(w / 2, h / 2), width: side, height: side);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, stroke);
        return;
      case GeoShape.rectangle:
        final rect = Rect.fromCenter(center: Offset(w / 2, h / 2), width: w * 0.9, height: h * 0.55);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, stroke);
        return;
      case GeoShape.triangle:
        path.moveTo(w / 2, h * 0.1);
        path.lineTo(w * 0.9, h * 0.9);
        path.lineTo(w * 0.1, h * 0.9);
        path.close();
        break;
      case GeoShape.pentagon:
        path = _polygon(w, h, 5);
        break;
      case GeoShape.hexagon:
        path = _polygon(w, h, 6);
        break;
      case GeoShape.trapezoid:
        path.moveTo(w * 0.3, h * 0.15);
        path.lineTo(w * 0.7, h * 0.15);
        path.lineTo(w * 0.9, h * 0.85);
        path.lineTo(w * 0.1, h * 0.85);
        path.close();
        break;
      case GeoShape.rhombus:
        path.moveTo(w / 2, h * 0.1);
        path.lineTo(w * 0.9, h / 2);
        path.lineTo(w / 2, h * 0.9);
        path.lineTo(w * 0.1, h / 2);
        path.close();
        break;
    }
    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);
  }

  Path _polygon(double w, double h, int sides) {
    final path = Path();
    final radius = w / 2.2;
    final center = Offset(w / 2, h / 2);
    for (int i = 0; i < sides; i++) {
      final angle = (2 * math.pi / sides) * i - math.pi / 2;
      final point = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.color != color;
}

class ShapeDisplay extends StatelessWidget {
  final GeoShape shape;
  final Color color;
  final double size;
  final String? label;

  const ShapeDisplay({
    super.key,
    required this.shape,
    this.color = Colors.blue,
    this.size = 100,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ShapePainter(shape: shape, color: color)),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(label!, style: Theme.of(context).textTheme.titleMedium),
        ],
      ],
    );
  }
}