import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:bloc/bloc.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  bool isEdit = false;
  bool userInit = false;
  String? address;
  String? latitude;
  String? longitude;
  late IamUserModel userModel;
  late UserLoginModel? userLoginModel;
  late UserPreferencesRepository _userPreferencesRepository;

  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileDataEvent>(fetchProfileDataEvent);
    on<UpdateProfileButtonEvent>(updateProfileButtonEvent);
    on<VerifyOtpButtonEvent>(verifyOtpButtonEvent);
    on<ProfileUpdatePasswordButtonEvent>(profileUpdatePasswordButtonEvent);
    on<ProfileAddNewAddressButtonEvent>(profileAddNewAddressButtonEvent);
    on<ProfileSaveNewAddressEvent>(profileSaveNewAddressEvent);
    on<ProfileRemoveAddressEvent>(profileRemoveAddressEvent);
    on<ProfileImageUpdateEvent>(profileImageUpdateEvent);
    on<ProfileMarkOnGoogleMapsEvent>(profileMarkOnGoogleMapsEvent);
    on<ProfileLocationInitialEvent>(profileLocationInitialEvent);
    on<ProfileLocationOnTapEvent>(profileLocationOnTapEvent);
    on<ProfileLocatinConfirmEvent>(profileLocatinConfirmEvent);
    on<ProfileOtpTimerStartEvent>(profileOtpTimerStartEvent);
    on<ProfileUpdateAddres>(profileUpdateAddres);
  }

  FutureOr<void> fetchProfileDataEvent(
      FetchProfileDataEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingSate());
    _userPreferencesRepository =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    userLoginModel = await _userPreferencesRepository.getUser();

    try {
      userModel = await AuthRepositories()
          .userGetIamId(identity: userLoginModel!.loggedUser.identityId);
      emit(ProfileDataState(model: userModel));
      EasyLoading.dismiss();
      userInit = true;
      log("User Iniziliezed ");
    } catch (e) {
      log("User fetch Error $e");
      userInit = false;
    }
  }

  FutureOr<void> updateProfileButtonEvent(
      UpdateProfileButtonEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingSate());

    // Validate email
    var emailValid = ValidationService.isValidEmail(event.email);

// Validate date of birth
    var dobValid = ValidationService.isValidDateOfBirth(event.dob);

// Validate first name
    var fNameValid =
        ValidationService.isValidName(event.fName, NameType.firstName);

// Validate last name
    var lNameValid =
        ValidationService.isValidName(event.lName, NameType.lastName);

    // Validate nic
    var nicValid = ValidationService.isValidNIC(event.nic);

// Validate mobile number
    var mobileValid = event.mob.isEmpty
        ? "Mobile number is\nrequired."
        : !ValidationService.isValidPhoneNumber(event.mob)
            ? "Enter valid mobile\nnumber!"
            : null;

    if (fNameValid != "valid") {
      emit(ProfileErrorState(msg: fNameValid));
    } else if (lNameValid != "valid") {
      emit(ProfileErrorState(msg: lNameValid));
    } else if (dobValid != 'valid') {
      emit(ProfileErrorState(msg: dobValid));
    } else if (nicValid != 'valid') {
      emit(ProfileErrorState(msg: nicValid));
    } else if (emailValid != 'valid') {
      emit(ProfileErrorState(msg: emailValid));
    } else if (mobileValid != null) {
      emit(ProfileErrorState(msg: mobileValid));
    } else if (event.model.mobile == event.mob) {
      var response = await UserRepositories().updateUserReop(
          firstname: event.fName,
          lastName: event.lName,
          dob: event.dob,
          email: event.email,
          mob: event.mob,
          nic: event.nic,
          url: event.model.profilePictureUrl,
          identityId: event.identityId);
      if (response == 200) {
        emit(ProfileUpdateSuccesState(email: event.email));
      } else {
        emit(const ProfileErrorState(msg: "Error!\nPlease try again."));
      }
    } else {
      var response =
          await AuthRepositories().initUpdateMobileReop(mobile: event.mob);

      if (response == 202) {
        emit(ProfileVerifyState(
          mob: event.mob,
          email: event.email,
          dob: event.dob,
          nic: event.nic,
          fName: event.fName,
          lName: event.lName,
          model: event.model,
        ));
      } else {
        emit(const ProfileErrorState(
            msg: "This number is in\nanother account!"));
      }
    }
  }

  FutureOr<void> verifyOtpButtonEvent(
      VerifyOtpButtonEvent event, Emitter<ProfileState> emit) async {
    if (event.otp.isEmpty) {
      emit(ProfileOtpErrorState());
      return;
    }

    var response = await AuthRepositories()
        .verifyOtpRepo(username: event.email, otp: event.otp);

    if (response != 400) {
      var authCode = response['result'];
      var responseUpdate = await AuthRepositories()
          .completeUpdateMobileReop(mobile: event.mob, authCode: authCode);
      if (responseUpdate == 201) {
        var response = await UserRepositories().updateUserReop(
            firstname: event.fName,
            lastName: event.lName,
            dob: event.dob,
            email: event.email,
            mob: event.mob,
            nic: event.nic,
            url: event.model.profilePictureUrl,
            identityId: event.identityId);
        if (response == 200) {
          emit(ProfileUpdateSuccesState(email: event.email));
        } else {
          emit(const ProfileErrorState(msg: "Error!\nPlease try again."));
        }
      } else {
        emit(const ProfileErrorState(msg: "Update Failed!\nPlease try again"));
      }
    } else {
      emit(const ProfileErrorState(msg: "Please enter valid\nOTP"));
    }
  }

  FutureOr<void> profileUpdatePasswordButtonEvent(
      ProfileUpdatePasswordButtonEvent event,
      Emitter<ProfileState> emit) async {
    emit(ProfileLoadingSate());
    // Validate password
    var passwordValid = ValidationService.isValidPassword(event.password);

    // Validate con password
    var newPasswordValid = ValidationService.isValidPassword(event.newPassword);

// Validate confirm password
    var confirmPassValid = ValidationService.isValidConfirmPassword(
        event.newPassword, event.conPassword);

    if (passwordValid != 'valid') {
      emit(ProfileErrorState(msg: passwordValid));
    } else if (newPasswordValid != 'valid') {
      emit(ProfileErrorState(msg: newPasswordValid));
    } else if (confirmPassValid != 'valid') {
      emit(ProfileErrorState(msg: confirmPassValid));
    } else if (event.password == event.newPassword) {
      emit(const ProfileErrorState(msg: "Current password can't\nbe reused."));
    } else {
      var response = await AuthRepositories().changePasswordReop(
          password: event.password, newPassword: event.newPassword);

      print(response);
      if (response == 200) {
        emit(ProfilePasswordUpdateStates());
      } else {
        emit(const ProfileErrorState(msg: "Password Update\nFailed"));
      }
    }
  }

  FutureOr<void> profileAddNewAddressButtonEvent(
      ProfileAddNewAddressButtonEvent event, Emitter<ProfileState> emit) {
    emit(ProfileLoadingSate());
    isEdit = !isEdit;
    emit(ProfileBillingaddressState());
  }

  FutureOr<void> profileSaveNewAddressEvent(
      ProfileSaveNewAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingSate());
    var validString =
        ValidationService.isValidString("Province", event.province);
    if ('valid' != validString) {
      emit(ProfileErrorState(msg: validString));
    } else if (event.city.isEmpty) {
      emit(const ProfileErrorState(msg: "City can't be empty!"));
    } else if (event.district.isEmpty) {
      emit(const ProfileErrorState(msg: "Area can't be empty!"));
    } else if (!event.isApartment && event.addressLine.isEmpty) {
      emit(const ProfileErrorState(msg: "Address\ncan't be empty"));
    } else if (event.isApartment && event.buildName.isEmpty) {
      emit(const ProfileErrorState(
          msg: "Apparment informations\nare required!"));
    } else if (event.isApartment && event.buildNo.isEmpty) {
      emit(const ProfileErrorState(
          msg: "Apparment informations\nare required!"));
    } else {
      var response = await UserRepositories().addNewAddressRepo(
          id: userModel.id,
          address: event.addressLine,
          city: event.city,
          district: event.district,
          province: event.province,
          postalCode: event.postalCode,
          latitude: event.latitude,
          builingName: event.buildName,
          builingNo: event.buildNo,
          longitude: event.longitude);
      if (response == 201) {
        isEdit = false;
        emit(ProfileBillingaddressState());
        emit(ProfileUpdateSuccesState(email: userModel.email));
      } else {
        emit(const ProfileErrorState(msg: "New Address update\nfailed!"));
      }
    }
  }

  FutureOr<void> profileRemoveAddressEvent(
      ProfileRemoveAddressEvent event, Emitter<ProfileState> emit) async {
    var response = await UserRepositories().removeAddressRepo(
        addressId: event.addressId,
        id: userModel.id,
        address: event.addressLine,
        city: event.city,
        district: event.district,
        province: event.province,
        postalCode: event.postalCode,
        latitude: event.latitude,
        longitude: event.longitude);
    if (response == 200) {
      emit(ProfileUpdateSuccesState(email: userModel.email));
    } else {
      emit(const ProfileErrorState(msg: "Remove Address\nfailed!"));
    }
  }

  FutureOr<void> profileImageUpdateEvent(
      ProfileImageUpdateEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileImageLoadingState());
    var response =
        await UserRepositories().updateImageFile(imageFile: event.imageFile);

    if (response is String) {
      var userUpdateResponse = await UserRepositories().updateUserReop(
          firstname: userModel.firstName,
          lastName: userModel.lastName,
          dob: userModel.dob.toIso8601String(),
          email: userModel.email,
          mob: userModel.mobile,
          nic: userModel.nic,
          url: response,
          identityId: event.identityId);

      if (userUpdateResponse == 200) {
        emit(ProfileUpdateSuccesState(email: userModel.email));
      } else {
        emit(const ProfileErrorState(msg: 'Image Update\nFailed'));
      }
    } else {
      emit(const ProfileErrorState(msg: 'Image Update\nFailed'));
    }
  }

  FutureOr<void> profileLocationOnTapEvent(
      ProfileLocationOnTapEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingSate());
    var placemark = await _getAddressFromLatLng(event.latLng);
    // creating a new MARKER
    var latLng = LatLng(event.latLng.latitude, event.latLng.longitude);
    final Marker marker = Marker(
      markerId: const MarkerId('Me'),
      position: latLng,
      infoWindow: const InfoWindow(title: 'Me', snippet: '*'),
    );
    emit(ProfileLocationUpdateState(
        latLng: latLng, placemark: placemark!, marker: marker));
  }

  Future<void> _getPermistion(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    _verifyDialog(context);
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _verifyDialog(BuildContext context) async {
    await showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.kMainBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: BlurryContainer(
                blur: 5,
                height: MediaQuery.sizeOf(context).height / 1.2,
                width: double.infinity,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white.withOpacity(0.03),
                child: MarkYourScreen()),
          );
        });
  }

  FutureOr<void> profileMarkOnGoogleMapsEvent(
      ProfileMarkOnGoogleMapsEvent event, Emitter<ProfileState> emit) {
    _getPermistion(event.context);
  }

  FutureOr<void> profileLocationInitialEvent(
      ProfileLocationInitialEvent event, Emitter<ProfileState> emit) async {
    var position = await _getCurrentPosition(event.context);
    var placemark = await _getAddressFromPosition(position);
    // creating a new MARKER
    var latLng = LatLng(position.latitude, position.longitude);
    final Marker marker = Marker(
      markerId: const MarkerId('Me'),
      position: latLng,
      infoWindow: const InfoWindow(title: 'Me', snippet: '*'),
    );
    emit(ProfileLocationUpdateState(
        latLng: latLng, placemark: placemark!, marker: marker));
  }

  Future<Placemark?> _getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks.isNotEmpty ? placemarks[0] : null;
    } catch (e) {
      // Handle the error or rethrow it
      debugPrint('Error getting address: $e');
      return null; // or throw an exception if needed
    }
  }

  Future<Placemark?> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      return placemarks.isNotEmpty ? placemarks[0] : null;
    } catch (e) {
      // Handle the error or rethrow it
      debugPrint('Error getting address: $e');
      return null; // or throw an exception if needed
    }
  }

  Future<Position> _getCurrentPosition(BuildContext context) async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      // Handle the error or rethrow it
      throw Exception('Failed to get current position: $e');
    }
  }

  FutureOr<void> profileLocatinConfirmEvent(
      ProfileLocatinConfirmEvent event, Emitter<ProfileState> emit) {
    address = event.address;
    latitude = event.latitude;
    longitude = event.longitude;
    emit(ProfileLocationConfirmState(context: event.context));
  }

  FutureOr<void> profileOtpTimerStartEvent(
      ProfileOtpTimerStartEvent event, Emitter<ProfileState> emit) {
    emit(ProfileOtpTimerStartState());
  }

  FutureOr<void> profileUpdateAddres(
      ProfileUpdateAddres event, Emitter<ProfileState> emit) async {
    try {
      var address = event.address;
      await UserRepositories().updateAddress(
          addressId: event.address.id,
          customerId: event.customerId,
          identityId: event.identityId,
          address: address.addressLine1,
          city: address.city,
          district: address.district,
          province: address.province,
          postalCode: address.postalCode,
          builingNo: address.bldNo,
          builingName: address.bldName,
          latitude: address.latitude,
          longitude: address.longitude,
          isDefault: event.value);

      emit(ProfileBillingaddressState());
      emit(ProfileUpdateSuccesState(email: userModel.email));
    } catch (e) {
      emit(const ProfileErrorState(msg: "Address update failed!"));
    }
  }
}
