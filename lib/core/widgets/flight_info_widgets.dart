import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class AirportInfo extends StatelessWidget {
  final String time;
  final String code;
  final String city;
  final CrossAxisAlignment timeAlignment;
  final CrossAxisAlignment infoAlignment;

  const AirportInfo({
    super.key,
    required this.time,
    required this.code,
    required this.city,
    this.timeAlignment = CrossAxisAlignment.start,
    this.infoAlignment = CrossAxisAlignment.start,
  });

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return '';
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return timeStr;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: _getAlignment(infoAlignment),
      child: Column(
        crossAxisAlignment: timeAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(time),
            style: AppTextStyles.time.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: _getAlignment(timeAlignment),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  code,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($city)',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return Alignment.centerLeft;
      case CrossAxisAlignment.end:
        return Alignment.centerRight;
      case CrossAxisAlignment.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}

class FlightRouteIndicator extends StatelessWidget {
  final String duration;
  final int stops;

  const FlightRouteIndicator({
    super.key,
    required this.duration,
    this.stops = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          height: 25,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(50, 25),
                painter: _RoutePainter(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              Positioned(
                top: 10,
                child: Image.asset(
                  'assets/icons/plane.png',
                  height: 18,
                  width: 18,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            duration,
            style: AppTextStyles.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
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
    final rect = Rect.fromLTWH(0, 5, size.width, size.height * 2);

    // Draw dashed arc
    final path = Path()..addArc(rect, 3.14159, 3.14159);

    final dashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 0.6, dashPaint);
        }
        distance += 4.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
