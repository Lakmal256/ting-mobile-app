import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late List<Address> addressList;
  late CurrentLocationCubit read;
  late Address address;

  bool isLoading = true;

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  void fetchLocation() async {
    read = context.read<CurrentLocationCubit>();
    addressList = context.read<ProfileBloc>().userModel.addressList;
    addressList.sort((a, b) => a.created.compareTo(b.created));
    await read.getLocation(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentLocationCubit, CurrentLocationState>(
        listener: (context, state) {
      if (state is CurrentLocationLoadingState) {
        isLoading = true;
      }
      if (state is CurrentLocationUpdatedState) {
        address = state.address;

        isLoading = false;
      }
      if (state is CurrentLocationRemovedState) {
        context.go(AppRoutes.authorized);
      }
    }, builder: (context, state) {
      return Scaffold(
          backgroundColor: AppColors.kMainBlue,
          appBar: AppBar(
            backgroundColor: AppColors.kMainBlue,
            elevation: 0,
            leading: IconButton(
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                icon: const Icon(Icons.navigate_before_rounded,
                    color: Colors.white, size: 35)),
            title: Image.asset(AssestPath.assestLogoPath,
                width: 100.0, fit: BoxFit.cover),
            centerTitle: false,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).width * 0.1),
                const AddAddressButton(),
                SizedBox(height: MediaQuery.sizeOf(context).width * 0.2),
                const RecentLocationsDivider(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColors.kBlue2,
                      borderRadius: BorderRadius.circular(15)),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : addressList.isEmpty
                          ? AspectRatio(
                              aspectRatio: 1.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AssestPath.emptyIcon),
                                  const SizedBox(height: 10),
                                  const CustomTextWidget(
                                      text: 'Address not found..',
                                      color: Colors.white,
                                      fontSize: 14),
                                ],
                              ))
                          : ListView.builder(
                              itemCount: addressList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  read.selectedAddress.id ==
                                          addressList[index].id
                                      ? read.unsaveLocation(context: context)
                                      : read.setLocation(
                                          address: addressList[index]);
                                  context.pop();
                                },
                                child: RecentLocationListItem(
                                  address: addressList[index],
                                  selectedAddress: address,
                                  showRemoveBtn: true,
                                ),
                              ),
                            ),
                )
              ],
            ),
          ));
    });
  }
}

class RecentLocationListItem extends StatelessWidget {
  const RecentLocationListItem({
    super.key,
    required this.address,
    required this.selectedAddress,
    required this.showRemoveBtn,
  });

  final Address address;
  final Address selectedAddress;
  final bool showRemoveBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: address.id == selectedAddress.id
          ? Colors.white.withOpacity(0.2)
          : null,
      padding: const EdgeInsets.only(bottom: 2, left: 5, right: 5, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    textAlign: TextAlign.left,
                    text: address.addressLine1.trim(),
                    fontSize: 16,
                  ),
                  CustomTextWidget(
                    text: "${address.city}, ${address.district}",
                    fontSize: 12,
                  )
                ],
              ),
              Visibility(
                visible: showRemoveBtn,
                child: InkWell(
                  onTap: () {
                    if (selectedAddress.id == address.id) {
                      context.read<ToastBloc>().add(MakeToastEvent(
                          message: "Unable to remove address in use",
                          context: context,
                          inShell: false));
                    } else {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, state) {
                              return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: AppColors.kBlue1,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                              width: 100,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: AppColors.kGray2
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              child: const Center(
                                                  child: Icon(
                                                      Icons
                                                          .arrow_drop_down_outlined,
                                                      color: Colors.white))),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Column(children: [
                                        const Icon(Icons.delete_outlined,
                                            color: AppColors.kGray2, size: 40),
                                        const SizedBox(height: 10),
                                        const CustomTextWidget(
                                            text:
                                                'Are you sure you want to remove this Address?',
                                            textAlign: TextAlign.center,
                                            color: Colors.white,
                                            fontSize: 16),
                                        const SizedBox(height: 20),
                                        CustomGradientButton(
                                            onPressed: () {
                                              context
                                                  .read<CurrentLocationCubit>()
                                                  .removeLocation(
                                                      addressId: address.id,
                                                      userId: context
                                                          .read<ProfileBloc>()
                                                          .userModel
                                                          .id,
                                                      addressLine:
                                                          address.addressLine1,
                                                      city: address.city,
                                                      district:
                                                          address.district,
                                                      latitude:
                                                          address.latitude,
                                                      longitude:
                                                          address.longitude,
                                                      postalCode:
                                                          address.postalCode,
                                                      province:
                                                          address.province);
                                            },
                                            width: double.infinity,
                                            height: 45,
                                            text: "Yes"),
                                        const SizedBox(height: 10),
                                        TextButton(
                                            onPressed: () => context.pop(),
                                            style: TextButton.styleFrom(
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap),
                                            child: CustomGradinetTextWidget(
                                              text: "No",
                                              style: CustomTextStyles
                                                  .textStyleGradientBold_15
                                                  .copyWith(
                                                      fontStyle:
                                                          FontStyle.italic),
                                            ))
                                      ]),
                                      const SizedBox(height: 50)
                                    ],
                                  ));
                            },
                          );
                        },
                      );
                    }
                  },
                  child: const SizedBox(
                    width: 60,
                    child: Icon(Icons.delete_outlined, color: AppColors.kGray2),
                  ),
                ),
              )
            ],
          ),
          const Divider(color: Colors.grey)
        ],
      ),
    );
  }
}

class RecentLocationsDivider extends StatelessWidget {
  const RecentLocationsDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            flex: 1,
            child: Divider(
              color: AppColors.kGray2,
              thickness: 0.5,
              height: 1,
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: CustomTextWidget(
              text: 'Recent Locations', color: AppColors.kGray2, fontSize: 14),
        ),
        Expanded(
            flex: 1,
            child: Divider(
              color: AppColors.kGray2,
              thickness: 0.5,
              height: 1,
            )),
      ],
    );
  }
}

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<TabViewCubit>().setTabPosition(position: 4);
        context.go(AppRoutes.settings);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: AppColors.kBlue2,
      leading: const Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
      title: const CustomTextWidget(
        text: 'Add address',
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.only(left: 10, right: 5),
      trailing: const Icon(
        Icons.navigate_next_rounded,
        color: Colors.white,
      ),
    );
  }
}
