import 'package:fight_app/core/widgets/app_animations.dart';
import 'package:fight_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double pagePadding = 16.0;

    return Scaffold(
      body: Container(
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
              padding: const EdgeInsets.all(pagePadding),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildSeatLegend(context),
                  const SizedBox(height: 40),
                  const SizedBox(
                    height: 400,
                    child: Center(
                      child: Text('Plane Layout', style: AppTextStyles.label),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildFooter(context),
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
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left,
                color: colorScheme.onSurface,
                size: 28,
              ),
            ),
          ),
        ),
        Text(
          'Select Seats',
          textAlign: TextAlign.center,
          style: AppTextStyles.title.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildSeatLegend(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(
          context,
          'Available',
          colorScheme.surface,
          colorScheme.outlineVariant,
        ),
        const SizedBox(width: 20),
        _legendItem(
          context,
          'Selected',
          colorScheme.primary,
          colorScheme.primary,
        ),
        const SizedBox(width: 20),
        _legendItem(
          context,
          'Booked',
          colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          Colors.transparent,
        ),
      ],
    );
  }

  Widget _legendItem(
    BuildContext context,
    String text,
    Color color,
    Color borderColor,
  ) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.label.copyWith(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Price',
                    style: AppTextStyles.label.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '\$963.00',
                    style: AppTextStyles.title.copyWith(
                      color: colorScheme.primary,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.push(AppRouter.bookingDetail),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
