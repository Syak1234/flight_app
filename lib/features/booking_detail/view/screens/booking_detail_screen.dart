import 'package:flight_app/core/widgets/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../viewmodel/booking_detail_viewmodel.dart';
import '../widgets/passenger_item.dart';
import '../widgets/barcode_widget.dart';
import '../widgets/ticket_card.dart';
import '../../../../core/widgets/flight_info_widgets.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = BookingDetailViewModel();
    const double pagePadding = 16.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Padding(
              padding: EdgeInsets.fromLTRB(
                pagePadding,
                12,
                pagePadding,
                0,
                // 40 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 25),
                  _buildFlightCard(context, viewModel),
                  const SizedBox(height: 16),
                  _buildPassengerCard(context, viewModel),
                  const SizedBox(height: 40),
                  _buildDownloadButton(context, viewModel),
                  const SizedBox(height: 20),
                ].animateStaggered(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Your flight details',
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              color: colorScheme.onSurface,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlightCard(BuildContext context, BookingDetailViewModel vm) {
    final booking = vm.booking;
    return TicketWidget(
      top: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          booking.airlineLogoText,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      booking.airlineName,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Text(
                  booking.tripId,
                  style: AppTextStyles.label.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AirportInfo(
                  time: booking.departureTime,
                  code: booking.departureCode,
                  city: booking.departureCity,
                  alignment: CrossAxisAlignment.start,
                ),
                FlightRouteIndicator(duration: booking.duration),
                AirportInfo(
                  time: booking.arrivalTime,
                  code: booking.arrivalCode,
                  city: booking.arrivalCity,
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailItem(context, 'TERMINAL', booking.terminal),
            _buildDetailItem(context, 'GATE', booking.gate),
            _buildDetailItem(context, 'Class', booking.travelClass),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(BuildContext context, BookingDetailViewModel vm) {
    return TicketWidget(
      top: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passengers Info',
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ...vm.booking.passengers.asMap().entries.map((entry) {
              final isLast = entry.key == vm.booking.passengers.length - 1;
              return Column(
                children: [
                  PassengerItem(passenger: entry.value, index: entry.key),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
      bottom: const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: BarcodeWidget(),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.value.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context, BookingDetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: vm.downloadAndSavePass,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Download & Save pass',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
