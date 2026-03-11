import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/flight_result/view/screens/flight_result_screen.dart';
import '../../features/flight_result/view/screens/seat_selection_screen.dart';
import '../../features/booking_detail/view/screens/booking_detail_screen.dart';
import '../widgets/error_screen.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String flightResults = '/flights';
  static const String seatSelection = '/seats';
  static const String bookingDetail = '/booking';

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
        builder: (context, state) => const FlightResultScreen(),
      ),
      GoRoute(
        path: seatSelection,
        builder: (context, state) => const SeatSelectionScreen(),
      ),
      GoRoute(
        path: bookingDetail,
        builder: (context, state) => const BookingDetailScreen(),
      ),
    ],
  );
}
