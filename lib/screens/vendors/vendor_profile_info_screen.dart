import 'dart:async';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/data/models/models.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class VendorProfileInfoScreen extends StatefulWidget {
  const VendorProfileInfoScreen({super.key, required this.profileModel});
  final VendorProfileModel profileModel;

  @override
  State<VendorProfileInfoScreen> createState() =>
      _VendorProfileInfoScreenState();
}

class _VendorProfileInfoScreenState extends State<VendorProfileInfoScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition kGooglePlex;
  late VendorsModel vendor;

  @override
  void initState() {
    vendor = context.read<VendorsBloc>().selectedVendorModel;
    kGooglePlex = CameraPosition(
        target: LatLng(vendor.latitude, vendor.longitude), zoom: 14.4746);
    updateCameraPosition(vendor: vendor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(
                aspectRatio: 1.5,
                child: Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: false,
                      initialCameraPosition: kGooglePlex,
                      mapType: MapType.terrain,
                      onMapCreated: (controller) =>
                          _controller.complete(controller),
                      markers: {
                        Marker(
                          markerId: MarkerId(vendor.name),
                          position: LatLng(vendor.latitude, vendor.longitude),
                        ), // Marker
                      },
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigate_before,
                            color: Colors.white,
                            size: 35,
                            shadows: [
                              Shadow(
                                  blurRadius: 1,
                                  color: Colors.black54,
                                  offset: Offset(1, 3))
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextWidget(
                  text: vendor.name.split('-').first,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Divider(color: AppColors.kGray2.withOpacity(0.3)),
            const SizedBox(height: 10),
            AddressBar(profileModel: widget.profileModel),
            const SizedBox(height: 10),
            Divider(color: AppColors.kGray2.withOpacity(0.3)),
            const SizedBox(height: 10),
            const ContactBar(),
            const SizedBox(height: 10),
            Divider(color: AppColors.kGray2.withOpacity(0.3)),
            const SizedBox(height: 10),
            AvailabilityWidget(vendor: vendor, widget: widget),
            const SizedBox(height: 10),
            Divider(color: AppColors.kGray2.withOpacity(0.3)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Expanded(
                      flex: 0,
                      child: Icon(
                        Icons.thumb_up,
                        color: AppColors.kBlue2,
                        size: 28,
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                            text:
                                widget.profileModel.rating ?? "0" " like this",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: AppColors.kGray2.withOpacity(0.3)),
          ]),
        ),
      ),
    );
  }

  void updateCameraPosition({required VendorsModel vendor}) {
    _controller.future.then((controller) => controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(vendor.latitude, vendor.longitude), zoom: 14))));

    // add marker with vendor location
  }
}

class AvailabilityWidget extends StatelessWidget {
  const AvailabilityWidget({
    super.key,
    required this.vendor,
    required this.widget,
  });

  final VendorsModel vendor;
  final VendorProfileInfoScreen widget;

  String _getOpenDaysText() {
    var value = widget.profileModel.openHours
        .map((openHour) => openHour.dayOfWeek)
        .toSet()
        .map((dayOfWeek) => dayOfWeek)
        .join(', ');

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.timelapse,
            color: AppColors.kBlue2,
            size: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomGradinetTextWidget(
                      text: vendor.open ? "Open" : "Close",
                      style: CustomTextStyles.textStyleWhiteBold_12
                          .copyWith(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.white, maxRadius: 2),
                          const SizedBox(width: 10),
                          DateWidget(
                            profileModel: widget.profileModel,
                            open: vendor.open,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomTextWidget(
                          text: _getOpenDaysText(),
                          fontSize: MediaQuery.of(context).size.width *
                              0.035, // adjust the multiplier to control the font size
                          color: AppColors.kGray1,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({super.key, required this.profileModel, required this.open});
  final VendorProfileModel profileModel;
  final bool open;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now);

    // Find the open hour object for the current day
    final checkDate =
        profileModel.openHours.where((date) => date.dayOfWeek == dayOfWeek);

    if (checkDate.isEmpty) {
      // Display a message if the vendor's opening hours are not available
      return const CustomTextWidget(
        text: "We are not open today",
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      final open = !checkDate.first.closed;

      if (open) {
        return CustomTextWidget(
          text: "Closed ${checkDate.first.endTime}",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
      } else {
        return CustomTextWidget(
          text: "Opens ${checkDate.first.startTime}",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
      }
    }
  }
}

class ContactBar extends StatelessWidget {
  const ContactBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
              flex: 0,
              child: Icon(
                Icons.call,
                color: AppColors.kBlue2,
                size: 30,
              )),
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                // TODO:  real contact no is required
                child: CustomTextWidget(
                    text: "011 555 2121",
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}

class AddressBar extends StatelessWidget {
  const AddressBar({
    super.key,
    required this.profileModel,
  });

  final VendorProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const Expanded(
              flex: 0,
              child: Icon(
                Icons.location_on,
                color: AppColors.kBlue2,
                size: 30,
              )),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomTextWidget(
                    text: profileModel.address.isEmpty
                        ? "-"
                        : profileModel.address,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 0,
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: profileModel.address));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Address copied"),
                ));
              },
              child: const Icon(
                Icons.copy,
                color: AppColors.kGray1,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
