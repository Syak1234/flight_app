import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/booking_model.dart';

class PassengerItem extends StatelessWidget {
  final PassengerModel passenger;
  final int index;

  const PassengerItem({
    super.key,
    required this.passenger,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            clipBehavior: Clip.antiAlias,
            child: passenger.photoUrl != null && passenger.photoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: passenger.photoUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => _buildInitialsAvatar(context),
                  )
                : _buildInitialsAvatar(context),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PASSENGER ${index + 1}',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black26,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  passenger.name,
                  style: AppTextStyles.value.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'SEAT',
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black26,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                passenger.seat,
                style: AppTextStyles.value.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(BuildContext context) {
    return Center(
      child: Text(
        _getInitials(passenger.name),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    
    final cleanParts = parts.where((p) => !['mr.', 'mrs.', 'ms.', 'dr.'].contains(p.toLowerCase())).toList();
    
    if (cleanParts.isEmpty) return '';
    if (cleanParts.length == 1) {
      return cleanParts[0].substring(0, 1).toUpperCase();
    }
    return '${cleanParts.first.substring(0, 1)}${cleanParts.last.substring(0, 1)}'.toUpperCase();
  }
}
