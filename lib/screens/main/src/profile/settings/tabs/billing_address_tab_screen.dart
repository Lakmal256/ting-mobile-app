import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/data/models/models.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toggle_switch/toggle_switch.dart';

class BilingAddressTabScreen extends StatelessWidget {
  const BilingAddressTabScreen({super.key, required this.userByEmailModel});

  final IamUserModel? userByEmailModel;

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().isEdit = false;
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (pre, current) {
        if (current is ProfileBillingaddressState) {
          return true;
        }
        if (pre is ProfileDataState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        var addressList = context.read<ProfileBloc>().userModel.addressList;
        // sort address list according to the created date
        addressList.sort((a, b) => a.created.compareTo(b.created));

        return context.read<ProfileBloc>().isEdit
            ? EditUpdateBilingInfoWidget(
                outlineInputBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.kMainGray),
                    borderRadius: BorderRadius.circular(12)))
            : Column(
                children: [
                  const SizedBox(height: 40),
                  userByEmailModel != null
                      ? SizedBox(
                          child: ListView.builder(
                            itemCount: addressList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Address address = addressList[index];
                              return SlidableCardWidget(
                                index: index,
                                address: address,
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                  CustomTransperantGradientButton(
                      onPressed: () => context
                          .read<ProfileBloc>()
                          .add(ProfileAddNewAddressButtonEvent()),
                      width: double.infinity,
                      height: 50,
                      text: 'Add New Address')
                ],
              );
      },
    );
  }
}

class SlidableCardWidget extends StatefulWidget {
  final int index;
  final Address address;
  const SlidableCardWidget(
      {super.key, required this.index, required this.address});

  @override
  State<SlidableCardWidget> createState() => _SlidableCardWidgetState();
}

class _SlidableCardWidgetState extends State<SlidableCardWidget> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const BehindMotion(), children: [
          SlidableAction(
            backgroundColor: AppColors.kMainGray,
            foregroundColor: Colors.white,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            label: 'Delete',
            onPressed: (context) {
              context.read<ProfileBloc>().add(ProfileRemoveAddressEvent(
                  addressId: widget.address.id,
                  addressLine: widget.address.addressLine1,
                  city: widget.address.city,
                  district: widget.address.district,
                  latitude: widget.address.latitude,
                  longitude: widget.address.longitude,
                  postalCode: widget.address.postalCode,
                  province: widget.address.province));
            },
            icon: Icons.delete_rounded,
          ),
        ]),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              gradient: LinearGradient(
                  colors: [AppColors.kMainOranage, AppColors.kMainPink])),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 5, bottom: 15, right: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // address title
                  Row(
                    children: [
                      CustomTextWidget(
                        text:
                            'Address 0${widget.index + 1} ${widget.address.bldName.isEmpty ? 'Home' : 'Appartment'}',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      const Spacer(),
                      Checkbox(
                          splashRadius: 0,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          semanticLabel: "Default",
                          side:
                              const BorderSide(color: Colors.white, width: 1.5),
                          checkColor: Colors.white,
                          focusColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white)),
                          value: widget.address.isDefault,
                          onChanged: (bool? newValue) async {
                            var read = context.read<ProfileBloc>();
                            read.add(ProfileUpdateAddres(
                                address: widget.address,
                                customerId: read.userLoginModel!.loggedUser.id
                                    .toString(),
                                identityId: read.userModel.id,
                                value: newValue!));

                            if (!newValue) {
                              context
                                  .read<CurrentLocationCubit>()
                                  .unsaveLocation(context: context);
                            } else {
                              context
                                  .read<CurrentLocationCubit>()
                                  .setLocation(address: widget.address);
                            }
                          }),
                      const CustomTextWidget(
                          text: "Default",
                          fontSize: 10,
                          fontWeight: FontWeight.bold)
                    ],
                  ),
                  // location
                  CustomTextWidget(
                      text: "${widget.address.city},${widget.address.province}",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: CustomTextWidget(
                        text: widget.address.addressLine1.isEmpty
                            ? '${widget.address.bldName},${widget.address.city}'
                            : widget.address.addressLine1,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class EditUpdateBilingInfoWidget extends StatefulWidget {
  final OutlineInputBorder outlineInputBorder;

  const EditUpdateBilingInfoWidget({
    super.key,
    required this.outlineInputBorder,
  });

  @override
  State<EditUpdateBilingInfoWidget> createState() =>
      _EditUpdateBilingInfoWidgetState();
}

class _EditUpdateBilingInfoWidgetState
    extends State<EditUpdateBilingInfoWidget> {
  var provinceTextEditController = TextEditingController();

  var cityTextEditController = TextEditingController();

  var areaTextEditController = TextEditingController();

  var postelCodeTextEditController = TextEditingController();

  var addressTextEditController = TextEditingController();
  var buildingNameTextEditController = TextEditingController();
  var appartmentNoTextEditController = TextEditingController();

  var landMarkTextEditingController = TextEditingController();

  int _index = 0;

  final List<String> provinces = [
    'Central',
    'Eastern',
    'Northern',
    'Southern',
    'Western',
    'North Western',
    'North Central',
    'Uva',
    'Sabaragamuwa'
  ];

  String? selectedProvince;

  List<String> centralProvince = ['Kandy', 'Matale', 'Nuwara Eliya'];
  List<String> easternProvince = ['Trincomalee', 'Batticaloa', 'Ampara'];
  List<String> northernProvince = [
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Mullaitivu',
    'Vavuniya'
  ];
  List<String> southernProvince = ['Galle', 'Matara', 'Hambantota'];
  List<String> westernProvince = ['Colombo', 'Gampaha', 'Kalutara'];
  List<String> northWesternProvince = ['Puttalam', 'Kurunegala'];
  List<String> northCentralProvince = ['Anuradhapura', 'Polonnaruwa'];
  List<String> uvaProvince = ['Badulla', 'Monaragala'];
  List<String> sabaragamuwaProvince = ['Ratnapura', 'Kegalle'];

  List<String> districts = [];

  String? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    var read = context.read<ProfileBloc>();
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLocationConfirmState) {
          if (read.address == null) return;
          addressTextEditController.text = read.address!;
        }
      },
      builder: (context, state) {
        return Column(children: [
          const SizedBox(height: 20),
          FittedBox(
            child: SizedBox(
              height: 50,
              child: ToggleSwitch(
                minWidth: double.infinity,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [AppColors.kMainOranage, AppColors.kMainPink],
                  [AppColors.kMainOranage, AppColors.kMainPink]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.white.withOpacity(0.1),
                inactiveFgColor: Colors.white,
                initialLabelIndex: _index,
                totalSwitches: 2,
                labels: const ['Home', 'Appartment'],
                animate: true,
                curve: Curves.elasticOut,
                animationDuration: 1000,
                customTextStyles: [
                  CustomTextStyles.textStyleWhiteBold_12.copyWith(fontSize: 15),
                  CustomTextStyles.textStyleWhiteBold_12.copyWith(fontSize: 15)
                ],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    _index = index!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Form(
              child: Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: "Province",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: widget.outlineInputBorder,
                      border: widget.outlineInputBorder,
                      focusedBorder: widget.outlineInputBorder,
                    ),
                    style: CustomTextStyles.textStyleWhiteBold_12,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedProvince = newValue;
                          provinceTextEditController.text = newValue;

                          switch (newValue) {
                            case 'Central':
                              districts
                                ..clear()
                                ..addAll(centralProvince);
                              break;
                            case 'Eastern':
                              districts
                                ..clear()
                                ..addAll(easternProvince);
                              break;
                            case 'Northern':
                              districts
                                ..clear()
                                ..addAll(northernProvince);
                              break;
                            case 'Southern':
                              districts
                                ..clear()
                                ..addAll(southernProvince);
                              break;
                            case 'Western':
                              districts
                                ..clear()
                                ..addAll(westernProvince);
                              break;
                            case 'North Western':
                              districts
                                ..clear()
                                ..addAll(northWesternProvince);
                              break;
                            case 'North Central':
                              districts
                                ..clear()
                                ..addAll(northCentralProvince);
                              break;
                            case 'Uva':
                              districts
                                ..clear()
                                ..addAll(uvaProvince);
                              break;
                            case 'Sabaragamuwa':
                              districts
                                ..clear()
                                ..addAll(sabaragamuwaProvince);
                              break;
                            default:
                              districts.clear();
                          }
                        });
                      }
                    },
                    dropdownColor: AppColors.kMainGray,
                    items:
                        provinces.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: TextField(
                      minLines: 1,
                      controller: cityTextEditController,
                      style: CustomTextStyles.textStyleWhiteBold_12,
                      decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          hintText: "City",
                          hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                          fillColor: AppColors.kMainGray,
                          enabledBorder: widget.outlineInputBorder,
                          border: widget.outlineInputBorder,
                          focusedBorder: widget.outlineInputBorder)),
                ),
              ]),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    onTap: selectedProvince == null
                        ? () => context.read<ToastBloc>().add(MakeToastEvent(
                            message: "Please select province frist!",
                            context: context))
                        : null,
                    decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        enabled: false,
                        hintText: "Area",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        labelText: selectedProvince == null ? "Area" : null,
                        labelStyle: CustomTextStyles.textStyleWhiteBold_12,
                        hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                        fillColor: AppColors.kMainGray,
                        enabledBorder: widget.outlineInputBorder,
                        border: widget.outlineInputBorder,
                        focusedBorder: widget.outlineInputBorder),
                    style: CustomTextStyles.textStyleWhiteBold_12,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue;
                        areaTextEditController.text = newValue!;
                      });
                    },
                    dropdownColor: AppColors.kMainGray,
                    items:
                        districts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: TextField(
                      minLines: 1,
                      controller: postelCodeTextEditController,
                      style: CustomTextStyles.textStyleWhiteBold_12,
                      decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          hintText: "Postal Code",
                          hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                          fillColor: AppColors.kMainGray,
                          enabledBorder: widget.outlineInputBorder,
                          border: widget.outlineInputBorder,
                          focusedBorder: widget.outlineInputBorder)),
                ),
              ]),
              _index == 1
                  ? const SizedBox(height: 15)
                  : const SizedBox.shrink(),
              Visibility(
                visible: _index == 1,
                child: TextField(
                    minLines: 1,
                    controller: appartmentNoTextEditController,
                    style: CustomTextStyles.textStyleWhiteBold_12,
                    decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        hintText: 'Apartment/Floor no',
                        hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                        fillColor: AppColors.kMainGray,
                        enabledBorder: widget.outlineInputBorder,
                        border: widget.outlineInputBorder,
                        focusedBorder: widget.outlineInputBorder)),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileMarkOnGoogleMapsEvent(context: context));
                },
                child: TextField(
                    minLines: 1,
                    style: CustomTextStyles.textStyleWhiteBold_12,
                    enabled: false,
                    decoration: InputDecoration(
                        prefixIcon: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.network(
                              "https://img.icons8.com/color/25/google-maps-new.png",
                              width: 20,
                            )),
                        filled: true,
                        isDense: true,
                        hintText: "Mark on Google Maps",
                        hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                        fillColor: AppColors.kMainGray,
                        enabledBorder: widget.outlineInputBorder,
                        border: widget.outlineInputBorder,
                        focusedBorder: widget.outlineInputBorder)),
              ),
              const SizedBox(height: 15),
              TextField(
                  minLines: 1,
                  controller: _index == 0
                      ? addressTextEditController
                      : buildingNameTextEditController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: _index == 0
                          ? "Billing Address"
                          : 'Apartment/Building name',
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: widget.outlineInputBorder,
                      border: widget.outlineInputBorder,
                      focusedBorder: widget.outlineInputBorder)),
              const SizedBox(height: 15),
              TextField(
                  minLines: 1,
                  controller: landMarkTextEditingController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: "Londmark (Optional)",
                      hintStyle: CustomTextStyles.textStyleWhiteBold_12,
                      fillColor: AppColors.kMainGray,
                      enabledBorder: widget.outlineInputBorder,
                      border: widget.outlineInputBorder,
                      focusedBorder: widget.outlineInputBorder)),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                        onPressed: () => context
                            .read<ProfileBloc>()
                            .add(ProfileAddNewAddressButtonEvent()),
                        style: ElevatedButton.styleFrom(
                            surfaceTintColor: AppColors.kPink1,
                            backgroundColor: AppColors.kPink1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const CustomTextWidget(
                          text: 'Cancel',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                        onPressed: () => context.read<ProfileBloc>().add(
                            ProfileSaveNewAddressEvent(
                                addressLine: addressTextEditController.text,
                                city: cityTextEditController.text,
                                district: areaTextEditController.text,
                                latitude: read.latitude == null
                                    ? 0.000
                                    : double.parse(read.latitude!),
                                longitude: read.longitude == null
                                    ? 0.000
                                    : double.parse(read.longitude!),
                                postalCode: postelCodeTextEditController.text,
                                province: provinceTextEditController.text,
                                isApartment: _index == 1,
                                buildName: buildingNameTextEditController.text,
                                buildNo: appartmentNoTextEditController.text)),
                        style: ElevatedButton.styleFrom(
                            surfaceTintColor: AppColors.kBlue2,
                            backgroundColor: AppColors.kBlue2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const CustomTextWidget(
                          text: 'Save',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
              const SizedBox(height: 15),
            ],
          )),
        ]);
      },
    );
  }
}
