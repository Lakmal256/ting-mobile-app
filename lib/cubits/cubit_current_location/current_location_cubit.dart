// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'current_location_state.dart';

class CurrentLocationCubit extends Cubit<CurrentLocationState> {
  CurrentLocationCubit() : super(CurrentLocationInitial());

  Position? position;
  Placemark? placemark;
  late Address selectedAddress;
  final _key = 'location_key';

  void setLocation({required Address address}) async {
    emit(CurrentLocationLoadingState());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    selectedAddress = address;
    preferences.setString(_key, jsonEncode(address));
    emit(CurrentLocationUpdatedState(address: address));
  }

  Future<void> unsaveLocation({required BuildContext context}) async {
    // remove saved location to make empty
    SharedPreferences.getInstance()
        .then((preferences) => preferences.remove(_key))
        .whenComplete(() async {
      await _getCurrentLocation(context);

      selectedAddress = Address(
          addressLine1: placemark!.street!,
          addressLine2: '',
          addressLine3: '',
          bldName: '',
          bldNo: '',
          city: '',
          created: DateTime.now(),
          district: placemark!.locality!,
          id: '0',
          latitude: position!.latitude,
          longitude: position!.longitude,
          nickname: '',
          postalCode: placemark!.postalCode!,
          province: placemark!.administrativeArea!,
          updated: DateTime.now(),
          isDefault: false);

      emit(CurrentLocationUpdatedState(address: selectedAddress));
    });
  }

  Future getLocation({required BuildContext context}) async {
    emit(CurrentLocationLoadingState());
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? address = preferences.getString(_key);

    if (address != null) {
      selectedAddress = addressFromJson(address);
      emit(CurrentLocationUpdatedState(address: selectedAddress));
    } else {
      await _getCurrentLocation(context);

      selectedAddress = Address(
          addressLine1: placemark!.street!,
          addressLine2: '',
          addressLine3: '',
          bldName: '',
          bldNo: '',
          city: '',
          created: DateTime.now(),
          district: placemark!.locality!,
          id: '0',
          latitude: position!.latitude,
          longitude: position!.longitude,
          nickname: '',
          postalCode: placemark!.postalCode!,
          province: placemark!.administrativeArea!,
          updated: DateTime.now(),
          isDefault: false);

      emit(CurrentLocationUpdatedState(address: selectedAddress));
    }
  }

  Future<void> removeLocation(
      {required String addressId,
      required String userId,
      required String addressLine,
      required String city,
      required String district,
      required double latitude,
      required double longitude,
      required String postalCode,
      required String province}) async {
    emit(CurrentLocationLoadingState());
    await UserRepositories().removeAddressRepo(
        addressId: addressId,
        id: userId,
        address: addressLine,
        city: city,
        district: district,
        province: province,
        postalCode: postalCode,
        latitude: latitude,
        longitude: longitude);

    emit(CurrentLocationRemovedState());
  }

  Future _getCurrentLocation(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;

    position = await _getCurrentPosition();
    placemark = await _getAddressFromPosition(position!);
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
        dismiss() => Navigator.pop(context);
        showLocationAcessAlert(context, dismiss);
        return false;
      } else {
        return true;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      final per = await Geolocator.requestPermission();
      if (per == LocationPermission.deniedForever) {
        showLocationAcessAlert(context, () => Navigator.pop(context));
        return false;
      } else {
        return true;
      }
    }
    return true;
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

  Future<Position> _getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      // Handle the error or rethrow it
      throw Exception('Failed to get current position: $e');
    }
  }

  showLocationAcessAlert(BuildContext context, VoidCallback dismiss) {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Access'),
        content: const Text(
            'This app requires location access. Please go to settings and enable location access.'),
        actions: [
          TextButton(
            onPressed: dismiss,
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
