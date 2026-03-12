import '../../domain/repositories/home_repository.dart';
import '../../data/models/saved_trip_model.dart';
import '../../../../core/database/database_helper.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<SavedTripModel>> getSavedTrips({int? limit, int? offset}) async {
    return await DatabaseHelper.instance.getSavedTrips(limit: limit, offset: offset);
  }
  @override
  Future<void> deleteSavedTrip(int id) async {
    await DatabaseHelper.instance.deleteTrip(id);
  }

  @override
  Future<int> getSavedTripsCount() async {
    return await DatabaseHelper.instance.getSavedTripsCount();
  }
}
