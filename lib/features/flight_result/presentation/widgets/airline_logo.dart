import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AirlineLogo extends StatelessWidget {
  final String imageUrl;

  const AirlineLogo({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => _fallbackLogo(),
        placeholder: (context, url) => _fallbackLogo(),
      ),
    );
  }

  Widget _fallbackLogo() {
    return Container(
      color: Colors.blue.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: const Icon(Icons.flight, color: Colors.blue, size: 24),
    );
  }
}
