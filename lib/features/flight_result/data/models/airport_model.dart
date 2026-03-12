class AirportModel {
  final String airportCode;
  final String city;
  final int flightCount;

  const AirportModel({
    required this.airportCode,
    required this.city,
    required this.flightCount,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      airportCode: json['airport_code'] ?? '',
      city: json['city'] ?? '',
      flightCount: json['flight_count'] ?? 0,
    );
  }

  @override
  String toString() {
    return '$city ($airportCode)';
  }
}
