import 'package:flutter/foundation.dart';

class SearchViewModel extends ChangeNotifier {
  DateTime _departureDate = DateTime.now();
  int _passengerCount = 3;
  String _fromLocation = 'Jakarta (CGK)';
  String _toLocation = 'Tokyo (NRT)';
  String? _error;

  DateTime get departureDate => _departureDate;
  int get passengerCount => _passengerCount;
  String get fromLocation => _fromLocation;
  String get toLocation => _toLocation;
  String? get error => _error;

  void setDepartureDate(DateTime date) {
    _departureDate = date;
    notifyListeners();
  }

  void setPassengerCount(int count) {
    _passengerCount = count;
    notifyListeners();
  }

  void changeLocation(String location, bool isDeparture) {
    if (isDeparture) {
      _fromLocation = location;
    } else {
      _toLocation = location;
    }
    notifyListeners();
  }

  void swapLocations() {
    final temp = _fromLocation;
    _fromLocation = _toLocation;
    _toLocation = temp;
    notifyListeners();
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }
}
