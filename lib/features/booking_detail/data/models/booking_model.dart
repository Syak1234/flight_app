class PassengerModel {
  final String name;
  final String seat;
  final String? photoUrl;

  const PassengerModel({
    required this.name,
    required this.seat,
    this.photoUrl,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      name: json['name'] ?? '',
      seat: json['seat'] ?? '',
      photoUrl: json['profile_picture'],
    );
  }
}

class BookingDetailModel {
  final String airlineName;
  final String airlineLogo;
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
  final String bookingReference;
  final int price;
  final List<PassengerModel> passengers;

  const BookingDetailModel({
    required this.airlineName,
    required this.airlineLogo,
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
    required this.bookingReference,
    required this.price,
    required this.passengers,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    final flight = json['flight_details'] ?? json;
    final passengersList = (json['passengers'] as List?)?.map((p) => PassengerModel.fromJson(p)).toList() ?? [];

    return BookingDetailModel(
      airlineName: flight['airline_name'] ?? '',
      airlineLogo: flight['airline_logo'] ?? '',
      tripId: (flight['flight_id'] ?? flight['id'] ?? '').toString(),
      departureCode: flight['departure']?['airport_code'] ?? '',
      departureCity: flight['departure']?['city'] ?? '',
      departureTime: flight['departure']?['time'] ?? '',
      arrivalCode: flight['arrival']?['airport_code'] ?? '',
      arrivalCity: flight['arrival']?['city'] ?? '',
      arrivalTime: flight['arrival']?['time'] ?? '',
      duration: flight['duration'] ?? '',
      terminal: flight['terminal'] ?? '',
      gate: flight['gate'] ?? '',
      travelClass: flight['class'] ?? '',
      bookingReference: json['booking_info']?['booking_reference'] ?? 'BK001',
      price: flight['price'] != null ? (flight['price']['amount'] ?? 0) : 0,
      passengers: passengersList,
    );
  }

  BookingDetailModel copyWith({
    String? airlineName,
    String? airlineLogo,
    String? tripId,
    String? departureCode,
    String? departureCity,
    String? departureTime,
    String? arrivalCode,
    String? arrivalCity,
    String? arrivalTime,
    String? duration,
    String? terminal,
    String? gate,
    String? travelClass,
    String? bookingReference,
    int? price,
    List<PassengerModel>? passengers,
  }) {
    return BookingDetailModel(
      airlineName: airlineName ?? this.airlineName,
      airlineLogo: airlineLogo ?? this.airlineLogo,
      tripId: tripId ?? this.tripId,
      departureCode: departureCode ?? this.departureCode,
      departureCity: departureCity ?? this.departureCity,
      departureTime: departureTime ?? this.departureTime,
      arrivalCode: arrivalCode ?? this.arrivalCode,
      arrivalCity: arrivalCity ?? this.arrivalCity,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      duration: duration ?? this.duration,
      terminal: terminal ?? this.terminal,
      gate: gate ?? this.gate,
      travelClass: travelClass ?? this.travelClass,
      bookingReference: bookingReference ?? this.bookingReference,
      price: price ?? this.price,
      passengers: passengers ?? this.passengers,
    );
  }
}
