import 'dart:ui';
import 'package:flight_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_animations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/flight_result_viewmodel.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/flight_card.dart';
import '../widgets/advanced_filter_sheet.dart';
import '../../../../core/widgets/no_data_found_widget.dart';

class FlightResultScreen extends StatefulWidget {
  final String fromCode;
  final String toCode;
  final int passengers;

  const FlightResultScreen({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.passengers,
  });

  @override
  State<FlightResultScreen> createState() => _FlightResultScreenState();
}

class _FlightResultScreenState extends State<FlightResultScreen> {
  late final FlightResultViewModel _viewModel;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _viewModel = FlightResultViewModel(
      fromCode: widget.fromCode,
      toCode: widget.toCode,
      passengers: widget.passengers,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _viewModel.fetchMoreFlights();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewModel.dispose();
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
          child: RefreshIndicator(
            onRefresh: _viewModel.fetchFlights,
            color: AppColors.primary,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        pagePadding,
                        12,
                        pagePadding,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 15),
                            FilterChipBar(
                              filters: _viewModel.filters,
                              selectedIndex: _viewModel.selectedFilterIndex,
                              onSelected: _viewModel.selectFilter,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 15)),
                    if (_viewModel.isLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_viewModel.error != null)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: pagePadding,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: NoDataFoundWidget(
                            title: 'Error Occurred',
                            subtitle: _viewModel.error!,
                            icon: Icons.error_outline_rounded,
                            onRetry: () => _viewModel.fetchFlights(),
                          ),
                        ),
                      )
                    else if (_viewModel.flights.isEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: pagePadding,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: NoDataFoundWidget(
                            title: 'No Flight Found',
                            subtitle:
                                'Try adjusting your search filters or dates.',
                            icon: Icons.flight_takeoff_rounded,
                            onRetry: () => _viewModel.fetchFlights(),
                          ),
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: pagePadding,
                        ),
                        sliver: SliverList.builder(
                          itemCount: _viewModel.flights.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FlightCard(
                                flight: _viewModel.flights[index],
                                onSelect: () => context.push(
                                  AppRouter.bookingDetail,
                                  extra: {
                                    'flightId': _viewModel.flights[index].id,
                                    'passengers': _viewModel.passengers,
                                  },
                                ),
                              ).animateStaggered(index: index),
                            );
                          },
                        ),
                      ),
                      if (_viewModel.isFetchingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: _buildFAB(context),
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
            'Flight result',
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGlassButton(
              context,
              icon: Icons.chevron_left,
              onTap: () => Navigator.pop(context),
            ),
            PopupMenuButton<String>(
              offset: const Offset(0, 50),
              onSelected: (value) {
                switch (value) {
                  case 'refresh':
                    _viewModel.fetchFlights();
                    break;
                  case 'clear':
                    _viewModel.resetFilters();
                    break;
                  case 'sort_az':
                    final index = _viewModel.sortOptions.indexWhere(
                      (e) => e['value'] == 'airline_asc',
                    );
                    if (index != -1) _viewModel.selectFilter(index);
                    break;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: colorScheme.surface.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              color: colorScheme.surface.withValues(alpha: 0.9),
              elevation: 4,
              shadowColor: Colors.black12,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'refresh',
                  child: _buildPremiumMenuItem(
                    context,
                    icon: Icons.refresh_rounded,
                    label: 'Refresh results',
                    iconColor: colorScheme.primary,
                  ),
                ),
                PopupMenuItem(
                  value: 'clear',
                  child: _buildPremiumMenuItem(
                    context,
                    icon: Icons.filter_alt_off_rounded,
                    label: 'Clear filters',
                    iconColor: Colors.redAccent,
                  ),
                ),
                PopupMenuItem(
                  value: 'sort_az',
                  child: _buildPremiumMenuItem(
                    context,
                    icon: Icons.sort_by_alpha_rounded,
                    label: 'A - Z Airline',
                    iconColor: Colors.blueAccent,
                  ),
                ),
              ],
              child: _buildGlassButton(
                context,
                icon: Icons.more_vert,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (context) => AdvancedFilterSheet(viewModel: _viewModel),
        );
      },
      backgroundColor: const Color(0xffbfd9fd),
      elevation: 0,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.filter_alt_outlined,
        color: Color(0xFF6c9bd6),
        size: 26,
      ),
    );
  }

  Widget _buildPremiumMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    double size = 28,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surface.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: colorScheme.onSurface, size: size),
          ),
        ),
      ),
    );
  }
}
