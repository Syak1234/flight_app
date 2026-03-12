import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_app/core/constants/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_animations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/home_viewmodel.dart';
import '../viewmodel/search_viewmodel.dart';
import '../widgets/search_form_card.dart';
import '../widgets/saved_trip_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  late final SearchViewModel _searchViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>();
    _searchViewModel = sl<SearchViewModel>();
    _viewModel.refreshSavedTrips();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF2F4F8),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Color(0xFF4A7FF7),
                    Color(0xFF7EAEFB),
                    Color(0xFFF2F4F8),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan your trip',
                            style: AppTextStyles.header.copyWith(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _buildAvatar(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SearchFormCard(viewModel: _searchViewModel),
                    const SizedBox(height: 25),
                    _buildSavedTripsSection(context, _viewModel),
                    const SizedBox(height: 20),
                  ].animateStaggered(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(context, _viewModel),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: CachedNetworkImage(
              imageUrl: AppStrings.userImage,
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(radius: 20, backgroundImage: imageProvider),
              placeholder: (context, url) => const _ShimmerCircle(radius: 20),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(radius: 20, child: Icon(Icons.person)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedTripsSection(BuildContext context, HomeViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved trips',
                style: AppTextStyles.title.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (vm.savedTrips.isNotEmpty)
                GestureDetector(
                  onTap: () => context.push('/saved-trips'),
                  child: Text(
                    'See more',
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: vm.savedTrips.isEmpty ? 120 : 205,
          child: vm.savedTrips.isEmpty
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_outline_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No trips saved yet',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your bookmarked flights will appear here for quick access.',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 13,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.savedTrips.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) => SizedBox(
                    width: 300,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SavedTripCard(trip: vm.savedTrips[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 60 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 'assets/icons/home.png', 0, vm),
          _buildNavItem(context, CupertinoIcons.airplane, 1, vm),
          _buildNavItem(context, Icons.map_outlined, 2, vm),
          _buildNavItem(context, Icons.person_outline, 3, vm),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    dynamic icon,
    int index,
    HomeViewModel vm,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = vm.navIndex == index;
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => vm.setNavIndex(index),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? constraints.maxWidth : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Center(
                    child: icon is String
                        ? Image.asset(
                            icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.35,
                                  ),
                            height: 24,
                            width: 24,
                          )
                        : Icon(
                            icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.35,
                                  ),
                            size: 24,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerCircle extends StatefulWidget {
  final double radius;

  const _ShimmerCircle({required this.radius});

  @override
  State<_ShimmerCircle> createState() => _ShimmerCircleState();
}

class _ShimmerCircleState extends State<_ShimmerCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CircleAvatar(
          radius: widget.radius,
          backgroundColor: Color.lerp(
            const Color(0xFFE0E0E0),
            const Color(0xFFF5F5F5),
            _animation.value,
          ),
          child: child,
        );
      },
      child: Icon(
        Icons.person,
        color: Colors.white.withValues(alpha: 0.6),
        size: widget.radius * 1.2,
      ),
    );
  }
}
