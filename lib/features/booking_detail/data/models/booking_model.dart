class PassengerModel {
  final String name;
  final String seat;
  final String? photoUrl;

  const PassengerModel({
    required this.name,
    required this.seat,
    this.photoUrl,
  });
}

class BookingDetailModel {
  final String airlineName;
  final String airlineLogoText;
  final String tripId;
  final String departureCode;
  final String departureCity;
  final String departureTime;
  final String arrivalCode;
  final String arrivalCity;
  final String arrivalTime;
  final String duration;
  final String terminal;
  final String gate;
  final String travelClass;
  final List<PassengerModel> passengers;

  const BookingDetailModel({
    required this.airlineName,
    required this.airlineLogoText,
    required this.tripId,
    required this.departureCode,
    required this.departureCity,
    required this.departureTime,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.arrivalTime,
    required this.duration,
    required this.terminal,
    required this.gate,
    required this.travelClass,
    required this.passengers,
  });
}
