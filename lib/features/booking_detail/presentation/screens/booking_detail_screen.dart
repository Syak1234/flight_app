import 'package:flight_app/core/widgets/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/booking_detail_viewmodel.dart';
import '../widgets/index.dart';
import '../../../../core/widgets/index.dart';
import '../../../flight_result/presentation/widgets/index.dart';
import '../../data/models/index.dart';

class BookingDetailScreen extends StatefulWidget {
  final int flightId;
  final int passengers;
  const BookingDetailScreen({
    super.key,
    required this.flightId,
    required this.passengers,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late final BookingDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = BookingDetailViewModel(
      flightId: widget.flightId,
      passengerCount: widget.passengers,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 25),
                    if (viewModel.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (viewModel.error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(viewModel.error!),
                        ),
                      )
                    else if (viewModel.booking != null) ...[
                      _buildFlightCard(context, viewModel.booking!),
                      const SizedBox(height: 16),
                      _buildPassengerCard(context, viewModel.booking!),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      _buildDownloadButton(context, viewModel),
                    ],
                    // const SizedBox(height: 20),
                  ].animateStaggered(),
                ),
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

  Widget _buildFlightCard(BuildContext context, BookingDetailModel booking) {
    return TicketWidget(
      top: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AirlineLogo(imageUrl: booking.airlineLogo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          booking.airlineName,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
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
                Expanded(
                  flex: 4,
                  child: AirportInfo(
                    time: booking.departureTime,
                    code: booking.departureCode,
                    city: booking.departureCity,
                    timeAlignment: CrossAxisAlignment.start,
                    infoAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FlightRouteIndicator(duration: booking.duration),
                ),
                Expanded(
                  flex: 4,
                  child: AirportInfo(
                    time: booking.arrivalTime,
                    code: booking.arrivalCode,
                    city: booking.arrivalCity,
                    timeAlignment: CrossAxisAlignment.end,
                    infoAlignment: CrossAxisAlignment.end,
                  ),
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

  Widget _buildPassengerCard(BuildContext context, BookingDetailModel booking) {
    return TicketWidget(
      top: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 7),
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
            ...booking.passengers.asMap().entries.map((entry) {
              final isLast = entry.key == booking.passengers.length - 1;
              return Column(
                children: [
                  const SizedBox(height: 4),
                  PassengerItem(passenger: entry.value, index: entry.key),
                  const SizedBox(height: 4),
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
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: BarcodeWidget(data: booking.bookingReference),
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

  void _showTopNotification(BuildContext context, DownloadResult result) {
    String title = '';
    String subTitle = '';
    IconData icon;
    Color iconColor;

    switch (result.status) {
      case SaveResult.success:
        title = 'Ticket Downloaded & Saved';
        subTitle = 'Saved to: ${result.path}';
        icon = Icons.check_circle_rounded;
        iconColor = Colors.greenAccent;
        break;
      case SaveResult.duplicate:
        title = 'Ticket Downloaded & Saved';
        subTitle = 'Saved to: ${result.path}';
        icon = Icons.check_circle_rounded;
        iconColor = Colors.greenAccent;
        break;
      case SaveResult.error:
        title = 'Download failed';
        subTitle = 'Please check permissions and try again';
        icon = Icons.error_rounded;
        iconColor = Colors.redAccent;
        break;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: -100.0, end: 0.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              final opacity = ((value + 100) / 100).clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(opacity: opacity, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                        if (subTitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subTitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => overlayEntry.remove(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  Widget _buildDownloadButton(BuildContext context, BookingDetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () async {
            final result = await vm.downloadAndSavePass();
            if (context.mounted) {
              _showTopNotification(context, result);
            }
          },
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
