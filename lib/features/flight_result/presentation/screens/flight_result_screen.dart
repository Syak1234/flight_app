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
                      padding: EdgeInsets.fromLTRB(pagePadding, 12, pagePadding, 0),
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
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_viewModel.error != null)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: pagePadding),
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
                        padding: const EdgeInsets.symmetric(horizontal: pagePadding),
                        sliver: SliverToBoxAdapter(
                          child: NoDataFoundWidget(
                            title: 'No Flight Found',
                            subtitle: 'Try adjusting your search filters or dates.',
                            icon: Icons.flight_takeoff_rounded,
                            onRetry: () => _viewModel.fetchFlights(),
                          ),
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: pagePadding),
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
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 28,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
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

          // ackgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (context) => AdvancedFilterSheet(viewModel: _viewModel),
        );
      },
      backgroundColor: const Color.fromARGB(255, 182, 214, 250),
      elevation: 0,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.filter_alt_outlined,
        color: Color(0xFF2A75F6),
        size: 26,
      ),
    );
  }
}
