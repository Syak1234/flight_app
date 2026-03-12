import 'package:flight_app/features/booking_detail/presentation/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/flight_info_widgets.dart';
import '../../data/models/flight_model.dart';
import 'airline_logo.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onSelect;

  const FlightCard({super.key, required this.flight, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      dividerEndIndent: 30,
      top: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildRoute(context),
          ],
        ),
      ),
      bottom: _buildFooter(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        AirlineLogo(imageUrl: flight.airlineLogo),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            flight.airlineName,
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildRoute(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: AirportInfo(
            time: flight.departureTime,
            code: flight.departureCode,
            city: flight.departureCity,
            timeAlignment: CrossAxisAlignment.start,
            infoAlignment: CrossAxisAlignment.start,
          ),
        ),
        Expanded(
          flex: 3,
          child: FlightRouteIndicator(
            duration: flight.duration,
            stops: flight.stops,
          ),
        ),
        Expanded(
          flex: 4,
          child: AirportInfo(
            time: flight.arrivalTime,
            code: flight.arrivalCode,
            city: flight.arrivalCity,
            timeAlignment: CrossAxisAlignment.start,
            infoAlignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${flight.price}',
                    style: AppTextStyles.value.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '/person',
                  style: AppTextStyles.label.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                elevation: 0,
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Select flight',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
