import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/models/saved_trip_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  List<SavedTripModel> getSavedTrips() {
    return const [
      SavedTripModel(
        airlineName: 'Citilink',
        airlineLogoText: 'Citilink',
        airlineLogoColor: AppColors.airlineCitilink,
        departureTime: '07:47',
        arrivalTime: '14:30',
        departureCode: 'CGK',
        departureCity: 'Jakarta',
        arrivalCode: 'NRT',
        arrivalCity: 'Tokyo',
        duration: '7h 15m',
        date: 'Jan 20, 2025',
      ),
      SavedTripModel(
        airlineName: 'Garuda',
        airlineLogoText: 'GA',
        airlineLogoColor: Color(0xFF1565C0),
        departureTime: '08:00',
        arrivalTime: '15:15',
        departureCode: 'CGK',
        departureCity: 'Jakarta',
        arrivalCode: 'NRT',
        arrivalCity: 'Tokyo',
        duration: '7h 15m',
        date: 'Jan 22, 2025',
      ),
    ];
  }
}
