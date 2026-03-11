import 'package:flutter/material.dart';
import '../data/models/booking_model.dart';

class BookingDetailViewModel extends ChangeNotifier {
  final BookingDetailModel booking = const BookingDetailModel(
    airlineName: 'Citilink Airline',
    airlineLogoText: 'Citilink',
    tripId: 'ID3242113',
    departureCode: 'CGK',
    departureCity: 'Jakarta',
    departureTime: '01:30 AM',
    arrivalCode: 'NRT',
    arrivalCity: 'Tokyo',
    arrivalTime: '01:30 AM',
    duration: '7h 15m',
    terminal: '2A',
    gate: '19',
    travelClass: 'Economy',
    passengers: [
      PassengerModel(
        name: 'Mr. Budiarti Rohman',
        seat: '3A',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
      ),
      PassengerModel(
        name: 'Mrs. Samantha William',
        seat: '3B',
        photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
      ),
    ],
  );

  void downloadAndSavePass() {
    debugPrint('Downloading and saving boarding pass...');
  }
}
