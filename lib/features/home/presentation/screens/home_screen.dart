import 'package:flight_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_animations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/services/home_service.dart';
import '../../data/services/home_service_impl.dart';
import '../widgets/search_form_card.dart';
import '../widgets/saved_trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepository _homeRepository;
  late final HomeService _homeService;
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _homeRepository = HomeRepositoryImpl();
    _homeService = HomeServiceImpl();
    _viewModel = HomeViewModel(_homeRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(_homeService),
      child: ListenableBuilder(
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
                  physics: PageScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
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
                      const SizedBox(height: 26),
                      const SearchFormCard(),
                      const SizedBox(height: 24),
                      _buildSavedTripsSection(context, _viewModel),
                      const SizedBox(height: 24),
                    ].animateStaggered(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context, _viewModel),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
      ),
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200&auto=format&fit=crop',
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
              Text(
                'See more',
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: vm.savedTrips.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                SavedTripCard(trip: vm.savedTrips[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 75 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                    height: 3,
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
                                : colorScheme.onSurfaceVariant.withOpacity(
                                    0.35,
                                  ),
                            height: 24,
                            width: 24,
                          )
                        : Icon(
                            icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant.withOpacity(
                                    0.35,
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
