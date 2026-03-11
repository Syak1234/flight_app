import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final DateTime departureDate;
  final int passengerCount;
  final String fromLocation;
  final String toLocation;
  final String? error;

  const SearchState({
    required this.departureDate,
    required this.passengerCount,
    required this.fromLocation,
    required this.toLocation,
    this.error,
  });

  SearchState copyWith({
    DateTime? departureDate,
    int? passengerCount,
    String? fromLocation,
    String? toLocation,
    String? error,
  }) {
    return SearchState(
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        departureDate,
        passengerCount,
        fromLocation,
        toLocation,
        error,
      ];
}
