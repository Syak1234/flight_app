import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/flight_info_widgets.dart';
import '../../../booking_detail/presentation/widgets/ticket_card.dart';
import '../../data/models/saved_trip_model.dart';

class SavedTripCard extends StatelessWidget {
  final SavedTripModel trip;

  const SavedTripCard({super.key, required this.trip});

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 350),
      child: TicketWidget(
        borderRadius: 24,
        notchRadius: 12,
        top: _buildTopSection(context),
        bottom: _buildBottomSection(context),
      ),
    );
  }

  Widget _buildAirlineLogo(BuildContext context) {
    if (trip.logoUrl != null && trip.logoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: trip.logoUrl!,
        height: 38,
        width: 65,
        fit: BoxFit.contain,
        placeholder: (context, url) => _buildFallbackLogo(),
        errorWidget: (context, url, error) => _buildFallbackLogo(),
      );
    }
    return _buildFallbackLogo();
  }

  Widget _buildFallbackLogo() {
    return Text(
      trip.airlineName,
      style: TextStyle(
        color: trip.airlineLogoColor,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Column(
        children: [
          _buildAirlineLogo(context),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: AirportInfo(
                  time: trip.departureTime,
                  code: trip.departureCode,
                  city: trip.departureCity,
                  timeAlignment: CrossAxisAlignment.start,
                  infoAlignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                flex: 3,
                child: FlightRouteIndicator(duration: trip.duration),
              ),
              Expanded(
                flex: 4,
                child: AirportInfo(
                  time: trip.arrivalTime,
                  code: trip.arrivalCode,
                  city: trip.arrivalCity,
                  timeAlignment: CrossAxisAlignment.start,
                  infoAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateColumn(context, _formatDate(trip.date), CrossAxisAlignment.start),
          _buildDateColumn(context, _formatDate(trip.date), CrossAxisAlignment.end),
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
        const SizedBox(height: 2),
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
