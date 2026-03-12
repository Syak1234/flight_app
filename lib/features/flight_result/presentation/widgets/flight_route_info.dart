import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class FlightRouteInfo extends StatelessWidget {
  final String departureTime;
  final String arrivalTime;
  final String departureCode;
  final String departureCity;
  final String arrivalCode;
  final String arrivalCity;
  final String duration;

  const FlightRouteInfo({
    super.key,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureCode,
    required this.departureCity,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAirport(
          context,
          departureTime,
          departureCode,
          departureCity,
          CrossAxisAlignment.start,
        ),
        Expanded(child: _buildRouteIcon(context)),
        _buildAirport(
          context,
          arrivalTime,
          arrivalCode,
          arrivalCity,
          CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _buildAirport(
    BuildContext context,
    String time,
    String code,
    String city,
    CrossAxisAlignment align,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          time,
          style: AppTextStyles.time.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              code,
              style: AppTextStyles.airportCode.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '($city)',
              style: AppTextStyles.airportCity.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteIcon(BuildContext context) {
    return Column(
      children: [
        Text(
          duration,
          style: AppTextStyles.label.copyWith(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.flight_takeoff,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
