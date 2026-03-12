import '../../data/models/airport_model.dart';

abstract class FlightRepository {
  Future<List<AirportModel>> getDepartureAirports(String search, int page);
  Future<List<AirportModel>> getArrivalAirports(String search, int page);
  Future<List<String>> getAirlines(String search, int page);
  Future<List<String>> getAircraftTypes(String search, int page);
  Future<Map<String, dynamic>> searchFlights({
    required String from,
    required String to,
    int passengers = 1,
    String sortBy = 'price_asc',
    String? airline,
    int? maxPrice,
    int? stops,
    String? aircraftType,
    int page = 1,
  });
  Future<Map<String, dynamic>> getFlightDetails(int id);
}
