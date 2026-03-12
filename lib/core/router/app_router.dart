import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/flight_result/presentation/screens/flight_result_screen.dart';
import '../../features/booking_detail/presentation/screens/booking_detail_screen.dart';
import '../../features/home/presentation/screens/airport_selection_screen.dart';
import '../../features/home/presentation/screens/saved_trips_screen.dart';
import '../widgets/error_screen.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String flightResults = '/flights';
  static const String bookingDetail = '/booking';
  static const String airportSelection = '/airport_selection';
  static const String savedTrips = '/saved-trips';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    errorBuilder: (context, state) => const GlobalErrorScreen(),
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: flightResults,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return FlightResultScreen(
            fromCode: extra['from'] as String? ?? 'CGK',
            toCode: extra['to'] as String? ?? 'NRT',
            passengers: extra['passengers'] as int? ?? 1,
          );
        },
      ),
      GoRoute(
        path: bookingDetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BookingDetailScreen(
            flightId: extra['flightId'] as int? ?? 1,
            passengers: extra['passengers'] as int? ?? 1,
          );
        },
      ),
      GoRoute(
        path: airportSelection,
        builder: (context, state) {
          final isDeparture = state.extra as bool? ?? true;
          return AirportSelectionScreen(isDeparture: isDeparture);
        },
      ),
      GoRoute(
        path: savedTrips,
        builder: (context, state) => const SavedTripsScreen(),
      ),
    ],
  );
}
