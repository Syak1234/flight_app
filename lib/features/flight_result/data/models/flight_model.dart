class FlightModel {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightNumber;
  final String departureTime;
  final String departureCode;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCode;
  final String arrivalCity;
  final String duration;
  final int price;
  final String currency;
  final String aircraftType;
  final int stops;

  const FlightModel({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.departureTime,
    required this.departureCode,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.duration,
    required this.price,
    required this.currency,
    required this.aircraftType,
    required this.stops,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'],
      airlineName: json['airline_name'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      departureTime: json['departure']['time'] ?? '',
      departureCode: json['departure']['airport_code'] ?? '',
      departureCity: json['departure']['city'] ?? '',
      arrivalTime: json['arrival']['time'] ?? '',
      arrivalCode: json['arrival']['airport_code'] ?? '',
      arrivalCity: json['arrival']['city'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']['amount'] ?? 0,
      currency: json['price']['currency'] ?? 'USD',
      aircraftType: json['aircraft_type'] ?? '',
      stops: json['stops'] ?? 0,
    );
  }
}
