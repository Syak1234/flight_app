import '../../data/models/saved_trip_model.dart';

abstract class HomeRepository {
  Future<List<SavedTripModel>> getSavedTrips({int? limit, int? offset});
  Future<void> deleteSavedTrip(int id);
  Future<int> getSavedTripsCount();
}
