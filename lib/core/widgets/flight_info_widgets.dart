import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class AirportInfo extends StatelessWidget {
  final String time;
  final String code;
  final String city;
  final CrossAxisAlignment alignment;

  const AirportInfo({
    super.key,
    required this.time,
    required this.code,
    required this.city,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: AppTextStyles.time.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              code,
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              '($city)',
              style: AppTextStyles.label.copyWith(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FlightRouteIndicator extends StatelessWidget {
  final String duration;

  const FlightRouteIndicator({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(50, 30),
                painter: _RoutePainter(
                  color: colorScheme.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/icons/plane.png',
                    height: 25,
                    width: 25,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          duration,
          style: AppTextStyles.label.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color color;

  _RoutePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.addArc(
      Rect.fromLTWH(0, 0, size.width, size.width),
      3.14159 * 1.05,
      3.14159 * 0.90,
    );

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (var pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 1.0, dotPaint);
        }
        distance += 5.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
