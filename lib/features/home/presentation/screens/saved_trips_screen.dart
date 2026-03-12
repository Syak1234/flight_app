import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_animations.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/saved_trip_card.dart';
import '../../../../core/widgets/no_data_found_widget.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _viewModel.loadMoreSavedTrips();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(pagePadding, 12, pagePadding, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                  if (_viewModel.allSavedTrips.isEmpty && !_viewModel.isLoadingMore)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: pagePadding),
                      sliver: SliverToBoxAdapter(
                        child: NoDataFoundWidget(
                          title: 'Your list is empty',
                          subtitle: 'Saved flights will be shown here after you bookmark them.',
                          icon: Icons.bookmark_outline_rounded,
                          onRetry: () => _viewModel.refreshSavedTrips(),
                        ),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: pagePadding),
                      sliver: SliverList.builder(
                        itemCount: _viewModel.allSavedTrips.length,
                        itemBuilder: (context, index) {
                          final trip = _viewModel.allSavedTrips[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Dismissible(
                              key: ValueKey(trip.id ?? index),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                              onDismissed: (direction) {
                                if (trip.id != null) {
                                  _viewModel.deleteSavedTrip(trip.id!);
                                }
                              },
                              child: SavedTripCard(trip: trip),
                            ).animateStaggered(index: index),
                          );
                        },
                      ),
                    ),
                    if (_viewModel.hasMore)
                      const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              );
            },
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saved Trips',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: colorScheme.onSurface,
                ),
              ),
              if (_viewModel.allSavedTrips.isNotEmpty)
                Text(
                  '${_viewModel.totalSavedTripsCount} trips saved',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
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
}
