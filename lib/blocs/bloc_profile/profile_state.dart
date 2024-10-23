part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingSate extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileErrorState extends ProfileState {
  final String msg;

  const ProfileErrorState({required this.msg});
  @override
  List<Object> get props => [msg];
}

class ProfileDataState extends ProfileState {
  final  IamUserModel model;

  const ProfileDataState({required this.model});
  @override
  List<Object> get props => [model];
}

class ProfileVerifyState extends ProfileState {
  final String fName;
  final String lName;
  final String dob;
  final String nic;
  final String email;
  final String mob;
  final  IamUserModel model;

  const ProfileVerifyState(
      {required this.fName,
      required this.lName,
      required this.dob,
      required this.nic,
      required this.email,
      required this.mob,
      required this.model});

  @override
  List<Object> get props => [];
}

class ProfileUpdateSuccesState extends ProfileState {
  final String email;
  const ProfileUpdateSuccesState({required this.email});
  @override
  List<Object> get props => [email];
}

class ProfilePasswordUpdateStates extends ProfileState {}

class ProfileBillingaddressState extends ProfileState {}

class ProfileImageLoadingState extends ProfileState {}

class ProfileGetCurrentLocationState extends ProfileState {}

class ProfileLocationUpdateState extends ProfileState {
  final LatLng latLng;
  final Placemark placemark;
  final Marker marker;

  const ProfileLocationUpdateState(
      {required this.latLng, required this.placemark, required this.marker});
}

class ProfileLocationConfirmState extends ProfileState {
  final BuildContext context;

  const ProfileLocationConfirmState({required this.context});
}

class ProfileOtpTimerStartState extends ProfileState {}

class ProfileOtpTimerStopState extends ProfileState {}

class ProfileOtpErrorState extends ProfileState {}
