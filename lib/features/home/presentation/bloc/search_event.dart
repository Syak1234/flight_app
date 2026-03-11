import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class ChangeDepartureDate extends SearchEvent {
  final BuildContext context;
  const ChangeDepartureDate(this.context);

  @override
  List<Object?> get props => [context];
}

class ChangePassengerCount extends SearchEvent {
  final BuildContext context;
  const ChangePassengerCount(this.context);

  @override
  List<Object?> get props => [context];
}

class SwapLocations extends SearchEvent {}

class ResetError extends SearchEvent {}
