import 'dart:ui';

class SavedTripModel {
  final int? id;
  final String airlineName;
  final String airlineLogoText;
  final Color airlineLogoColor;
  final String departureTime;
  final String arrivalTime;
  final String departureCode;
  final String departureCity;
  final String arrivalCode;
  final String arrivalCity;
  final String duration;
  final String? logoUrl;
  final String date;

  const SavedTripModel({
    this.id,
    required this.airlineName,
    required this.airlineLogoText,
    required this.airlineLogoColor,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureCode,
    required this.departureCity,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.duration,
    this.logoUrl,
    required this.date,
  });
}
