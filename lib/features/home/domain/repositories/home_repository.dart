import '../../data/models/saved_trip_model.dart';

abstract class HomeRepository {
  List<SavedTripModel> getSavedTrips();
}
