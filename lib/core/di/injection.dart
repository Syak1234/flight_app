import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/flight_result/domain/repositories/flight_repository.dart';
import '../../features/flight_result/data/repositories/flight_repository_impl.dart';
import '../../features/home/presentation/viewmodel/home_viewmodel.dart';
import '../../features/home/presentation/viewmodel/search_viewmodel.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerLazySingleton<FlightRepository>(() => FlightRepositoryImpl(sl()));

  sl.registerLazySingleton<HomeViewModel>(() => HomeViewModel(sl()));
  sl.registerFactory<SearchViewModel>(() => SearchViewModel());
}
