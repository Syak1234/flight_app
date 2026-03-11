import 'package:flutter/material.dart';
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
              image: passenger.photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(passenger.photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: passenger.photoUrl == null
                ? Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  )
                : null,
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
}
