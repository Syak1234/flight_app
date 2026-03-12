import 'package:flight_app/features/flight_result/domain/repositories/flight_repository.dart';
import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/database/database_helper.dart';
import '../../../home/data/models/saved_trip_model.dart';
import '../../../home/presentation/viewmodel/home_viewmodel.dart';

enum SaveResult { success, duplicate, error }

class BookingDetailViewModel extends ChangeNotifier {
  BookingDetailModel? _booking;
  BookingDetailModel? get booking => _booking;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  late final FlightRepository _repository;
  final int passengerCount;

  BookingDetailViewModel({
    required int flightId,
    required this.passengerCount,
  }) {
    _repository = sl<FlightRepository>();
    fetchFlightDetails(flightId);
  }

  Future<void> fetchFlightDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getFlightDetails(id);
      final model = BookingDetailModel.fromJson(result);

      // Truncate passengers list based on search criteria
      if (model.passengers.length > passengerCount) {
        final truncatedPassengers = model.passengers.take(passengerCount).toList();
        _booking = model.copyWith(passengers: truncatedPassengers);
      } else {
        _booking = model;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SaveResult> downloadAndSavePass() async {
    if (_booking == null) return SaveResult.error;

    try {
      final trip = SavedTripModel(
        airlineName: _booking!.airlineName,
        airlineLogoText: _booking!.airlineName,
        airlineLogoColor: const Color(0xFF1976D2),
        departureTime: _booking!.departureTime,
        arrivalTime: _booking!.arrivalTime,
        departureCode: _booking!.departureCode,
        departureCity: _booking!.departureCity,
        arrivalCode: _booking!.arrivalCode,
        arrivalCity: _booking!.arrivalCity,
        duration: _booking!.duration,
        logoUrl: _booking!.airlineLogo,
        date: DateTime.now().toString().split(' ').first,
      );

      final result = await DatabaseHelper.instance.saveTrip(trip);
      
      if (result == -1) {
        return SaveResult.duplicate;
      }

      await sl<HomeViewModel>().refreshSavedTrips();
      return SaveResult.success;
    } catch (e) {
      debugPrint('Error saving pass: $e');
      return SaveResult.error;
    }
  }
}
