import 'package:flight_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_animations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../viewmodel/flight_result_viewmodel.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/flight_card.dart';

class FlightResultScreen extends StatefulWidget {
  const FlightResultScreen({super.key});

  @override
  State<FlightResultScreen> createState() => _FlightResultScreenState();
}

class _FlightResultScreenState extends State<FlightResultScreen> {
  late final FlightResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FlightResultViewModel();
  }

  @override
  void dispose() {
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
          child: SingleChildScrollView(
            physics: PageScrollPhysics(),

            child: Padding(
              padding: EdgeInsets.fromLTRB(pagePadding, 12, pagePadding, 0),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 15),
                    FilterChipBar(
                      filters: _viewModel.filters,
                      selectedIndex: _viewModel.selectedFilterIndex,
                      onSelected: _viewModel.selectFilter,
                    ),
                    const SizedBox(height: 15),
                    ...List.generate(
                      _viewModel.flights.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FlightCard(
                          flight: _viewModel.flights[index],
                          onSelect: () => context.push(AppRouter.seatSelection),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ].animateStaggered(),
                ),
              ),
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
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
      onPressed: () {},
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
