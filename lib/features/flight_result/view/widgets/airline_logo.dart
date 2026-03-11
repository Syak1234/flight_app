import 'package:flutter/material.dart';

class AirlineLogo extends StatelessWidget {
  final String text;
  final Color color;

  const AirlineLogo({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9, // Small text like in BookingDetailScreen
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
