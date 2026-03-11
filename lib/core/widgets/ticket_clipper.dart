import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchPosition;

  TicketClipper({this.notchRadius = 10, this.notchPosition = 0.7});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * notchPosition - notchRadius);
    path.arcToPoint(
      Offset(0, size.height * notchPosition + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: true,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * notchPosition + notchRadius);
    path.arcToPoint(
      Offset(size.width, size.height * notchPosition - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: true,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
