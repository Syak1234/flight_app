import 'dart:isolate';
import '../models/flight_model.dart';
import '../models/airport_model.dart';
import '../../../../core/network/api_client.dart';

import '../../domain/repositories/flight_repository.dart';

class FlightRepositoryImpl implements FlightRepository {
  final ApiClient apiClient;

  FlightRepositoryImpl(this.apiClient);

  @override
  Future<List<AirportModel>> getDepartureAirports(
    String search,
    int page,
  ) async {
    final response = await apiClient.post(
      '/airports/from',
      data: {'search': search, 'limit': 20, 'page': page},
    );
    final List<dynamic> airportsJson = response['airports'] ?? [];
    return Isolate.run(
      () => airportsJson.map((e) => AirportModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<AirportModel>> getArrivalAirports(String search, int page) async {
    final response = await apiClient.post(
      '/airports/to',
      data: {'search': search, 'limit': 20, 'page': page},
    );
    final List<dynamic> airportsJson = response['airports'] ?? [];
    return Isolate.run(
      () => airportsJson.map((e) => AirportModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<String>> getAirlines(String search, int page) async {
    final response = await apiClient.post(
      '/airlines',
      data: {'search': search, 'limit': 20, 'page': page},
    );
    final List<dynamic> airlinesJson = response['airlines'] ?? [];
    return Isolate.run(
      () => airlinesJson.map((e) => e['airline'].toString()).toList(),
    );
  }

  @override
  Future<List<String>> getAircraftTypes(String search, int page) async {
    final response = await apiClient.post(
      '/aircraft-types',
      data: {'search': search, 'limit': 20, 'page': page},
    );
    final List<dynamic> aircraftsJson = response['aircraft_types'] ?? [];
    return Isolate.run(
      () => aircraftsJson.map((e) => e['aircraft'].toString()).toList(),
    );
  }

  @override
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
  }) async {
    final data = {
      'from': from,
      'to': to,
      'passengers': passengers,
      'sort_by': sortBy,
      'limit': 10,
      'page': page,
      'filters': {
        'airline': airline ?? '',
        'price_min': 0,
        'price_max': maxPrice ?? 0,
        'stops': stops ?? '',
        'aircraft_type': aircraftType ?? '',
      },
    };

    final response = await apiClient.post('/search', data: data);
    final List<dynamic> flightsJson = response['flights'] ?? [];

    final parsedFlights = await Isolate.run(
      () => flightsJson.map((e) => FlightModel.fromJson(e)).toList(),
    );

    return {'flights': parsedFlights, 'pagination': response['pagination']};
  }

  @override
  Future<Map<String, dynamic>> getFlightDetails(int id) async {
    final response = await apiClient.post('/flight', data: {'id': id});
    return response;
  }
}
