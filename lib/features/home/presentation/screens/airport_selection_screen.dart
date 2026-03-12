import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../flight_result/data/models/airport_model.dart';
import '../../../flight_result/domain/repositories/flight_repository.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/no_data_found_widget.dart';

class AirportSelectionScreen extends StatefulWidget {
  final bool isDeparture;
  const AirportSelectionScreen({super.key, required this.isDeparture});

  @override
  State<AirportSelectionScreen> createState() => _AirportSelectionScreenState();
}

class _AirportSelectionScreenState extends State<AirportSelectionScreen> {
  late final FlightRepository _repository;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<AirportModel> _airports = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = sl<FlightRepository>();
    _fetchAirports('');
  }

  Future<void> _fetchAirports(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = widget.isDeparture
          ? await _repository.getDepartureAirports(query, 1)
          : await _repository.getArrivalAirports(query, 1);

      setState(() {
        _airports = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: pagePadding, vertical: 12),
                child: _buildHeader(context),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: pagePadding),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? NoDataFoundWidget(
                            title: 'Error Occurred',
                            subtitle: _error!,
                            icon: Icons.error_outline_rounded,
                            onRetry: () => _fetchAirports(_searchController.text),
                          )
                        : _airports.isEmpty
                            ? NoDataFoundWidget(
                                title: 'No Airport Found',
                                subtitle: 'Try searching for another city or code.',
                                onRetry: () => _fetchAirports(''),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(pagePadding, 0, pagePadding, 24),
                                itemCount: _airports.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final airport = _airports[index];
                                  return _buildAirportCard(airport);
                                },
                              ),
              ),
            ],
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
            widget.isDeparture ? 'Where from?' : 'Where to?',
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
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: AppTextStyles.value.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search city or airport code',
          hintStyle: AppTextStyles.label.copyWith(
            fontSize: 15,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _fetchAirports('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        onChanged: (val) {
          setState(() {}); // Update suffix icon
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 400), () {
            _fetchAirports(val);
          });
        },
      ),
    );
  }

  Widget _buildAirportCard(AirportModel airport) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(
            context,
            '${airport.city} (${airport.airportCode})',
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.isDeparture ? Icons.flight_takeoff_rounded : Icons.flight_land_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      airport.city,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${airport.city} International Airport',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F7FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  airport.airportCode,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
