import 'package:flutter/material.dart';
import '../data/models/flight_model.dart';

class FlightResultViewModel extends ChangeNotifier {
  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  final List<String> filters = [
    'Lowest to Highest',
    'Preferred airlines',
    'Flight time',
  ];

  final List<FlightModel> flights = const [
    FlightModel(
      airlineName: 'Citilink Airline',
      airlineLogoText: 'Citilink',
      airlineLogoColor: Color(0xFF4CAF50),
      departureTime: '07:47',
      arrivalTime: '14:30',
      departureCode: 'CGK',
      departureCity: 'Jakarta',
      arrivalCode: 'NRT',
      arrivalCity: 'Tokyo',
      duration: '7h 15m',
      pricePerPerson: 321,
    ),
    FlightModel(
      airlineName: 'Catty Airline',
      airlineLogoText: 'CatAir',
      airlineLogoColor: Color(0xFFE53935),
      departureTime: '07:47',
      arrivalTime: '14:30',
      departureCode: 'CGK',
      departureCity: 'Jakarta',
      arrivalCode: 'NRT',
      arrivalCity: 'Tokyo',
      duration: '7h 20m',
      pricePerPerson: 321,
    ),
    FlightModel(
      airlineName: 'Bird Indonesia Airline',
      airlineLogoText: 'BIA',
      airlineLogoColor: Color(0xFF1565C0),
      departureTime: '07:47',
      arrivalTime: '14:30',
      departureCode: 'CGK',
      departureCity: 'Jakarta',
      arrivalCode: 'NRT',
      arrivalCity: 'Tokyo',
      duration: '7h 20m',
      pricePerPerson: 321,
    ),
  ];

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }
}
