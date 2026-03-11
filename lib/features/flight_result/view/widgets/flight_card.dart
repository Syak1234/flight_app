import 'package:fight_app/features/booking_detail/view/widgets/ticket_card.dart';
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
      // dividerIndent: 10,
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
        AirlineLogo(
          text: flight.airlineLogoText,
          color: flight.airlineLogoColor,
        ),
        const SizedBox(width: 12),
        Text(
          flight.airlineName,
          style: AppTextStyles.title.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRoute(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AirportInfo(
          time: flight.departureTime,
          code: flight.departureCode,
          city: flight.departureCity,
        ),
        FlightRouteIndicator(duration: flight.duration),
        AirportInfo(
          time: flight.arrivalTime,
          code: flight.arrivalCode,
          city: flight.arrivalCity,
          alignment: CrossAxisAlignment.start,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${flight.pricePerPerson}',
                style: AppTextStyles.value.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
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
          ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
            ),
            child: const Text(
              'Select flight',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
