import 'dart:ui';
import 'package:flight_app/core/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/search_viewmodel.dart';

class SearchFormCard extends StatefulWidget {
  final SearchViewModel viewModel;

  const SearchFormCard({super.key, required this.viewModel});

  @override
  State<SearchFormCard> createState() => _SearchFormCardState();
}

class _SearchFormCardState extends State<SearchFormCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _scaleAnimation;

  SearchViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutQuart),
      ),
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );

    vm.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (vm.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      vm.resetError();
    }
  }

  @override
  void dispose() {
    vm.removeListener(_onViewModelChanged);
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
    vm.swapLocations();
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final colorScheme = Theme.of(context).colorScheme;

    DateTime selectedDate =
        vm.departureDate.isBefore(today) ? today : vm.departureDate;

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Select Departure Date',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                      ),
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: colorScheme.copyWith(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: Colors.transparent,
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: selectedDate,
                            firstDate: today,
                            lastDate: today.add(const Duration(days: 365)),
                            onDateChanged: (date) {
                              setModalState(() => selectedDate = date);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(context, selectedDate),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Confirm Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      vm.setDepartureDate(result);
    }
  }

  Future<void> _showPassengerCountPicker() async {
    int? count = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        int localCount = vm.passengerCount;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Number of Passengers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _counterButton(
                        icon: Icons.remove,
                        onTap: localCount > 1
                            ? () {
                                setModalState(() => localCount--);
                              }
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          '$localCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _counterButton(
                        icon: Icons.add,
                        onTap: localCount < 10
                            ? () {
                                setModalState(() => localCount++);
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, localCount),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
    if (count != null) {
      vm.setPassengerCount(count);
    }
  }

  Widget _counterButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: onTap != null ? Colors.black : Colors.black26,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildLocationSection(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildInfoRow(context),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildSearchButton(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            InkWell(
              onTap: () async {
                final result = await context.push<String>(
                  AppRouter.airportSelection,
                  extra: true,
                );
                if (result != null) {
                  vm.changeLocation(result, true);
                }
              },
              child: _buildField(context, 'From', vm.fromLocation),
            ),
            Divider(
              height: 1,
              color: colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            InkWell(
              onTap: () async {
                final result = await context.push<String>(
                  AppRouter.airportSelection,
                  extra: false,
                );
                if (result != null) {
                  vm.changeLocation(result, false);
                }
              },
              child: _buildField(context, 'To', vm.toLocation),
            ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _showDatePicker,
              child: _buildIconField(
                context,
                'Departure',
                DateFormat('E, d MMM').format(vm.departureDate),
                CupertinoIcons.calendar,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: _showPassengerCountPicker,
              child: _buildIconField(
                context,
                'Amount',
                '${vm.passengerCount} people',
                CupertinoIcons.chevron_down,
              ),
            ),
          ),
        ],
      ),
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
        onPressed: () {
          String extractCode(String location) {
            final match = RegExp(r'\(([^)]+)\)').firstMatch(location);
            return match != null ? match.group(1) ?? '' : location;
          }

          final fromCode = extractCode(vm.fromLocation);
          final toCode = extractCode(vm.toLocation);
          context.push(
            AppRouter.flightResults,
            extra: {
              'from': fromCode,
              'to': toCode,
              'passengers': vm.passengerCount,
            },
          );
        },
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
