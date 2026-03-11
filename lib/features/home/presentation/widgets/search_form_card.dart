import 'package:fight_app/core/router/app_router.dart';
import 'package:fight_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:fight_app/features/home/presentation/bloc/search_event.dart';
import 'package:fight_app/features/home/presentation/bloc/search_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_text_styles.dart';

class SearchFormCard extends StatefulWidget {
  const SearchFormCard({super.key});

  @override
  State<SearchFormCard> createState() => _SearchFormCardState();
}

class _SearchFormCardState extends State<SearchFormCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOutQuart),
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _swapLocations() {
    if (_controller.isAnimating) return;

    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    context.read<SearchBloc>().add(SwapLocations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<SearchBloc>().add(ResetError());
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.50),
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                _buildLocationSection(context),
                _buildInfoRow(context),
                const SizedBox(height: 20),
                _buildSearchButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            Column(
              children: [
                _buildField(context, 'From', state.fromLocation),
                Divider(
                  height: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                _buildField(context, 'To', state.toLocation),
                Divider(
                  height: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ],
            ),
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: _swapLocations,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: _buildSwapCircle(context),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildField(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 24,
            width: double.infinity,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInQuad,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerLeft,
                key: ValueKey<String>(value),
                child: Text(
                  value,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapCircle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        CupertinoIcons.arrow_up_arrow_down,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: 20,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.read<SearchBloc>().add(
                        ChangeDepartureDate(context),
                      ),
                  child: _buildIconField(
                    context,
                    'Departure',
                    DateFormat('E, d MMM').format(state.departureDate),
                    CupertinoIcons.calendar,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => context.read<SearchBloc>().add(
                        ChangePassengerCount(context),
                      ),
                  child: _buildIconField(
                    context,
                    'Amount',
                    '${state.passengerCount} people',
                    CupertinoIcons.chevron_down,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => context.push(AppRouter.flightResults),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Search flights',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
