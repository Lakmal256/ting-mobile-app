import 'dart:async';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class MarkYourScreen extends StatelessWidget {
  MarkYourScreen({super.key});
  static const id = 'mark_location';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  var addressTextEditController = TextEditingController();
  var latTextEditingController = TextEditingController();
  var longTextEdingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context
        .read<ProfileBloc>()
        .add(ProfileLocationInitialEvent(context: context));
    CameraPosition kGooglePlex =
        const CameraPosition(target: LatLng(6.927079, 79.861244), zoom: 14.4746);

    var outlineInputBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.kMainGray),
        borderRadius: BorderRadius.circular(12));

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLocationUpdateState) {
          EasyLoading.dismiss();
          markers.clear();
          markers[state.marker.markerId] = state.marker;
          updateCameraPosition(state);
        } else if (state is ProfileLocationConfirmState) {
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 15),
              const CustomTextWidget(
                text: 'Mark Your Location',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GoogleMap(
                      myLocationEnabled: true,
                      initialCameraPosition: kGooglePlex,
                      mapType: MapType.terrain,
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                      },
                      onTap: (latlang) => context
                          .read<ProfileBloc>()
                          .add(ProfileLocationOnTapEvent(latLng: latlang)),
                      markers: Set<Marker>.of(markers.values)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                  minLines: 2,
                  maxLines: 3,
                  controller: addressTextEditController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: "Billing Address",
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder)),
              const SizedBox(height: 10),
              TextField(
                  controller: latTextEditingController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: "Latitude",
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder)),
              const SizedBox(height: 10),
              TextField(
                  controller: longTextEdingController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: "Longitude",
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomGradientButton(
                    onPressed: () => context.read<ProfileBloc>().add(
                        ProfileLocatinConfirmEvent(
                            context: context,
                            address: addressTextEditController.text,
                            latitude: latTextEditingController.text,
                            longitude: longTextEdingController.text)),
                    width: double.infinity,
                    height: 45,
                    text: 'Confirm'),
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(LinearBorder.none)),
                  onPressed: () {
                    addressTextEditController.clear();
                    context.read<ProfileBloc>().add(ProfileLocatinConfirmEvent(
                        context: context,
                        address: addressTextEditController.text,
                        latitude: latTextEditingController.text,
                        longitude: longTextEdingController.text));
                  },
                  child: const CustomGradinetTextWidget(
                    text: "Back",
                  ))
            ],
          ),
        );
      },
    );
  }

  void updateCameraPosition(ProfileLocationUpdateState state) {
    _controller.future.then((controller) => controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(state.latLng.latitude, state.latLng.longitude),
            zoom: 15))));
    var placemark = state.placemark;
    addressTextEditController.text = '${placemark.name},${placemark.locality}';
    latTextEditingController.text = '${state.latLng.latitude}';
    longTextEdingController.text = '${state.latLng.longitude}';
  }
}
