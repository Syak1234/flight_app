import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/home_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeService _homeService;

  SearchBloc(this._homeService)
      : super(
          SearchState(
            departureDate: DateTime.now(),
            passengerCount: 3,
            fromLocation: 'Jakarta (CGK)',
            toLocation: 'Tokyo (NRT)',
          ),
        ) {
    on<ChangeDepartureDate>(_onChangeDate);
    on<ChangePassengerCount>(_onChangePassengerCount);
    on<SwapLocations>(_onSwapLocations);
    on<ResetError>(_onResetError);
  }

  Future<void> _onChangeDate(
    ChangeDepartureDate event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final date = await _homeService.selectDate(
        event.context,
        state.departureDate,
      );
      if (date != null) {
        emit(state.copyWith(departureDate: date));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to select date'));
    }
  }

  Future<void> _onChangePassengerCount(
    ChangePassengerCount event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final count = await _homeService.selectPassengerCount(
        event.context,
        state.passengerCount,
      );
      if (count != null) {
        emit(state.copyWith(passengerCount: count));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to select passenger count'));
    }
  }

  void _onSwapLocations(SwapLocations event, Emitter<SearchState> emit) {
    final from = state.fromLocation;
    final to = state.toLocation;
    emit(state.copyWith(fromLocation: to, toLocation: from));
  }

  void _onResetError(ResetError event, Emitter<SearchState> emit) {
    emit(state.copyWith(error: null));
  }
}
