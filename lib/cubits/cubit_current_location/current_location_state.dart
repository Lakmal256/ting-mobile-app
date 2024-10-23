part of 'current_location_cubit.dart';

sealed class CurrentLocationState extends Equatable {
  const CurrentLocationState();

  @override
  List<Object> get props => [];
}

final class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationLoadingState extends CurrentLocationState {}

class CurrentLocationRemovedState extends CurrentLocationState {}

class CurrentLocationUpdatedState extends CurrentLocationState {
  final Address address;

  const CurrentLocationUpdatedState({required this.address});

  @override
  List<Object> get props => [address];
}
