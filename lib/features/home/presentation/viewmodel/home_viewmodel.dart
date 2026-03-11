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

  void _loadSavedTrips() {
    _savedTrips = _homeRepository.getSavedTrips();
    notifyListeners();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }
}
