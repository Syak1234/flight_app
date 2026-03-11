import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/flight_info_widgets.dart';
import '../../../../core/widgets/ticket_clipper.dart';
import '../../data/models/saved_trip_model.dart';

class SavedTripCard extends StatelessWidget {
  final SavedTripModel trip;

  const SavedTripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(notchRadius: 12, notchPosition: 0.65),
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTopSection(context),
            _buildDashedDivider(context),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Citilink_Logo.svg/1200px-Citilink_Logo.svg.png',
            height: 32,
            width: 130,
            fit: BoxFit.contain,
            errorBuilder: (context, _, e) => Text(
              trip.airlineName,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AirportInfo(
                time: trip.departureTime,
                code: trip.departureCode,
                city: trip.departureCity,
                alignment: CrossAxisAlignment.start,
              ),
              FlightRouteIndicator(duration: trip.duration),
              AirportInfo(
                time: trip.arrivalTime,
                code: trip.arrivalCode,
                city: trip.arrivalCity,
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider(BuildContext context) {
    return Row(
      children: List.generate(
        40,
        (i) => Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: i % 2 == 0
                ? Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateColumn(context, trip.date, CrossAxisAlignment.start),
          _buildDateColumn(context, trip.date, CrossAxisAlignment.end),
        ],
      ),
    );
  }

  Widget _buildDateColumn(
    BuildContext context,
    String date,
    CrossAxisAlignment alignment,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          'DATE',
          style: AppTextStyles.label.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: AppTextStyles.title.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
