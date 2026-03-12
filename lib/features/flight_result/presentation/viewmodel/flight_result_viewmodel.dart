import 'package:flutter/material.dart';
import '../../data/models/flight_model.dart';
import '../../domain/repositories/flight_repository.dart';
import '../../../../core/di/injection.dart';

class FlightResultViewModel extends ChangeNotifier {
  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _selectedAirline;
  int? _maxPrice;
  int? _stops;
  String? _selectedAircraftType;

  String? get selectedAirline => _selectedAirline;
  int? get maxPrice => _maxPrice;
  int? get stops => _stops;
  String? get selectedAircraftType => _selectedAircraftType;

  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  int _totalFlights = 0;

  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;
  int get totalFlights => _totalFlights;

  final List<Map<String, String>> sortOptions = [
    {'title': 'Lowest Price', 'value': 'price_asc'},
    {'title': 'Highest Price', 'value': 'price_desc'},
    {'title': 'Shortest Time', 'value': 'duration_asc'},
    {'title': 'Earliest Departure', 'value': 'departure_asc'},
  ];

  List<String> get filters => sortOptions.map((e) => e['title']!).toList();

  List<FlightModel> _flights = [];
  List<FlightModel> get flights => _flights;

  late final FlightRepository _repository;

  final String fromCode;
  final String toCode;
  final int passengers;

  FlightResultViewModel({
    required this.fromCode,
    required this.toCode,
    required this.passengers,
  }) {
    _repository = sl<FlightRepository>();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    _isLoading = true;
    _error = null;
    _page = 1;
    _hasMore = true;
    _flights = [];
    notifyListeners();

    try {
      final String sortBy = sortOptions[_selectedFilterIndex]['value']!;

      final result = await _repository.searchFlights(
        from: fromCode,
        to: toCode,
        passengers: passengers,
        sortBy: sortBy,
        airline: _selectedAirline,
        maxPrice: _maxPrice,
        stops: _stops,
        aircraftType: _selectedAircraftType,
        page: _page,
      );

      _flights = List<FlightModel>.from(result['flights'] ?? []);
      _parsePagination(result['pagination']);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreFlights() async {
    if (_isLoading || _isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    _page++;
    notifyListeners();

    try {
      final String sortBy = sortOptions[_selectedFilterIndex]['value']!;

      final result = await _repository.searchFlights(
        from: fromCode,
        to: toCode,
        passengers: passengers,
        sortBy: sortBy,
        airline: _selectedAirline,
        maxPrice: _maxPrice,
        stops: _stops,
        aircraftType: _selectedAircraftType,
        page: _page,
      );

      final newFlights = List<FlightModel>.from(result['flights'] ?? []);
      _flights.addAll(newFlights);
      _parsePagination(result['pagination']);
    } catch (e) {
      _page--; // Revert page on failure
      debugPrint('Error fetching more flights: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void _parsePagination(dynamic paginationData) {
    if (paginationData != null && paginationData is Map) {
      _hasMore = paginationData['hasNextPage'] ?? false;
      _totalFlights = paginationData['total'] ?? _flights.length;
    } else {
      _hasMore = false;
    }
  }

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    fetchFlights();
  }

  void applyAdvancedFilters({
    String? airline,
    int? maxPrice,
    int? stops,
    String? aircraftType,
  }) {
    _selectedAirline = airline;
    _maxPrice = maxPrice;
    _stops = stops;
    _selectedAircraftType = aircraftType;
    fetchFlights();
  }
}
