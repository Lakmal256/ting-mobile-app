part of 'profile_bloc.dart';

class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileDataEvent extends ProfileEvent {
  const FetchProfileDataEvent();
  @override
  List<Object> get props => [];
}

class UpdateProfileButtonEvent extends ProfileEvent {
  final String fName;
  final String lName;
  final String dob;
  final String nic;
  final String email;
  final String mob;
  final IamUserModel model;
  final String identityId;

  const UpdateProfileButtonEvent(
      {required this.fName,
      required this.lName,
      required this.dob,
      required this.nic,
      required this.email,
      required this.mob,
      required this.model,
      required this.identityId});

  @override
  List<Object> get props => [fName, lName, dob, email, mob, model, identityId];
}

class VerifyOtpButtonEvent extends ProfileEvent {
  final String otp;
  final String fName;
  final String lName;
  final String dob;
  final String email;
  final String mob;
  final String nic;
  final IamUserModel model;
  final String identityId;

  const VerifyOtpButtonEvent(
      {required this.otp,
      required this.fName,
      required this.lName,
      required this.dob,
      required this.email,
      required this.mob,
      required this.nic,
      required this.model,
      required this.identityId});

  @override
  List<Object> get props =>
      [otp, fName, lName, dob, email, mob, model, identityId];
}

class ProfileUpdatePasswordButtonEvent extends ProfileEvent {
  final String password;
  final String newPassword;
  final String conPassword;

  const ProfileUpdatePasswordButtonEvent(
      {required this.password,
      required this.newPassword,
      required this.conPassword});

  @override
  List<Object> get props => [password, newPassword];
}

class ProfileAddNewAddressButtonEvent extends ProfileEvent {}

class ProfileSaveNewAddressEvent extends ProfileEvent {
  final String addressLine;
  final String city;
  final String district;
  final double latitude;
  final double longitude;
  final String postalCode;
  final String province;
  final bool isApartment;
  final String buildName;
  final String buildNo;

  const ProfileSaveNewAddressEvent(
      {required this.addressLine,
      required this.city,
      required this.district,
      required this.latitude,
      required this.longitude,
      required this.postalCode,
      required this.province,
      required this.isApartment,
      required this.buildName,
      required this.buildNo});
}

class ProfileRemoveAddressEvent extends ProfileEvent {
  final String addressId;
  final String addressLine;
  final String city;
  final String district;
  final double latitude;
  final double longitude;
  final String postalCode;
  final String province;

  const ProfileRemoveAddressEvent(
      {required this.addressId,
      required this.addressLine,
      required this.city,
      required this.district,
      required this.latitude,
      required this.longitude,
      required this.postalCode,
      required this.province});
}

class ProfileUpdateAddres extends ProfileEvent {
  final Address address;
  final String customerId;
  final String identityId;
  final bool value;

  const ProfileUpdateAddres(
      {required this.address,
      required this.customerId,
      required this.identityId, required this.value});
}

class ProfileImageUpdateEvent extends ProfileEvent {
  final File imageFile;
  final String identityId;

  const ProfileImageUpdateEvent(
      {required this.imageFile, required this.identityId});
}

class ProfileMarkOnGoogleMapsEvent extends ProfileEvent {
  final BuildContext context;

  const ProfileMarkOnGoogleMapsEvent({required this.context});
}

class ProfileLocationInitialEvent extends ProfileEvent {
  final BuildContext context;

  const ProfileLocationInitialEvent({required this.context});
}

class ProfileLocationConfirmEvent extends ProfileEvent {
  final BuildContext context;

  const ProfileLocationConfirmEvent({required this.context});
}

class ProfileLocationOnTapEvent extends ProfileEvent {
  final LatLng latLng;
  const ProfileLocationOnTapEvent({required this.latLng});
}

class ProfileLocatinConfirmEvent extends ProfileEvent {
  final BuildContext context;
  final String address;
  final String latitude;
  final String longitude;
  const ProfileLocatinConfirmEvent(
      {required this.context,
      required this.address,
      required this.latitude,
      required this.longitude});
}

class ProfileOtpTimerStartEvent extends ProfileEvent {}

class ProfileOtpSubmitEvent extends ProfileEvent {}
