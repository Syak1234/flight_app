import 'package:flutter/material.dart';
import '../../data/models/saved_trip_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _homeRepository;
  
  HomeViewModel(this._homeRepository) {
    _loadSavedTrips();
  }

  int _navIndex = 0;
  int get navIndex => _navIndex;

  List<SavedTripModel> _savedTrips = [];
  List<SavedTripModel> get savedTrips => _savedTrips;

  // Pagination state
  final List<SavedTripModel> _allSavedTrips = [];
  List<SavedTripModel> get allSavedTrips => _allSavedTrips;
  
  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _totalSavedTripsCount = 0;
  int get totalSavedTripsCount => _totalSavedTripsCount;

  Future<void> _loadSavedTrips() async {
    _totalSavedTripsCount = await _homeRepository.getSavedTripsCount();
    _savedTrips = await _homeRepository.getSavedTrips(limit: 3);
    
    // Reset full list pagination
    _allSavedTrips.clear();
    _currentPage = 0;
    _hasMore = true;
    await loadMoreSavedTrips();
    
    notifyListeners();
  }

  Future<void> deleteSavedTrip(int id) async {
    await _homeRepository.deleteSavedTrip(id);
    _allSavedTrips.removeWhere((trip) => trip.id == id);
    _totalSavedTripsCount--;
    _savedTrips = await _homeRepository.getSavedTrips(limit: 3);
    notifyListeners();
  }

  Future<void> loadMoreSavedTrips() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextBatch = await _homeRepository.getSavedTrips(
      limit: _pageSize,
      offset: _currentPage * _pageSize,
    );

    if (nextBatch.length < _pageSize) {
      _hasMore = false;
    }

    _allSavedTrips.addAll(nextBatch);
    _currentPage++;
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refreshSavedTrips() async {
    await _loadSavedTrips();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }
}
