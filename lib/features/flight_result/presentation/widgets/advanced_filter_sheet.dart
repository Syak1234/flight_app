import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../viewmodel/flight_result_viewmodel.dart';
import '../../domain/repositories/flight_repository.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_animations.dart';

class AdvancedFilterSheet extends StatefulWidget {
  final FlightResultViewModel viewModel;

  const AdvancedFilterSheet({super.key, required this.viewModel});

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  late FlightRepository _repository;

  List<String> _airlines = [];
  bool _isLoadingAirlines = true;
  String? _selectedAirline;

  List<String> _aircraftTypes = [];
  bool _isLoadingAircrafts = true;
  String? _selectedAircraftType;

  double _maxPrice = 5000;
  int? _selectedStops;

  @override
  void initState() {
    super.initState();
    _repository = sl<FlightRepository>();
    _selectedAirline = widget.viewModel.selectedAirline;
    _maxPrice = widget.viewModel.maxPrice?.toDouble() ?? 5000;
    _selectedStops = widget.viewModel.stops;
    _selectedAircraftType = widget.viewModel.selectedAircraftType;

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _fetchAirlines();
        _fetchAircraftTypes();
      }
    });
  }

  Future<void> _fetchAirlines() async {
    try {
      final airlines = await _repository.getAirlines('', 1);
      if (mounted) {
        setState(() {
          _airlines = airlines;
          _isLoadingAirlines = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingAirlines = false);
    }
  }

  Future<void> _fetchAircraftTypes() async {
    try {
      final types = await _repository.getAircraftTypes('', 1);
      if (mounted) {
        setState(() {
          _aircraftTypes = types;
          _isLoadingAircrafts = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingAircrafts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.backgroundGradient,
        ),
      ),
      width: double.infinity,

      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: AppTextStyles.title.copyWith(fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedAirline = null;
                          _maxPrice = 5000;
                          _selectedStops = null;
                          _selectedAircraftType = null;
                        });
                      },
                      child: Text(
                        'Reset',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  'Max Price',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$0', style: AppTextStyles.label),
                    Text(
                      '\$${_maxPrice.toInt()}',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _maxPrice,
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primaryLight,
                  onChanged: (val) {
                    setState(() => _maxPrice = val);
                  },
                ),
                const SizedBox(height: 24),

                Text(
                  'Stops',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStopChip('Any', null),
                    _buildStopChip('Direct', 0),
                    _buildStopChip('1 Stop', 1),
                    _buildStopChip('2+ Stops', 2),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Airlines',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (_isLoadingAirlines)
                  const CircularProgressIndicator()
                else if (_airlines.isEmpty)
                  Text('No airlines found', style: AppTextStyles.label)
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _airlines.map((airline) {
                      final isSelected = _selectedAirline == airline;
                      return ChoiceChip(
                        label: Text(airline),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedAirline = selected ? airline : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),

                Text(
                  'Aircraft Type',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (_isLoadingAircrafts)
                  const CircularProgressIndicator()
                else if (_aircraftTypes.isEmpty)
                  Text('No aircraft types found', style: AppTextStyles.label)
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _aircraftTypes.map((type) {
                      final isSelected = _selectedAircraftType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedAircraftType = selected ? type : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.viewModel.applyAdvancedFilters(
                        airline: _selectedAirline,
                        maxPrice: _maxPrice > 0 ? _maxPrice.toInt() : null,
                        stops: _selectedStops,
                        aircraftType: _selectedAircraftType,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ].animateStaggered(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopChip(String label, int? value) {
    final isSelected = _selectedStops == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : Colors.grey.withValues(alpha: 0.2),
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      onSelected: (_) {
        setState(() => _selectedStops = value);
      },
    );
  }
}
