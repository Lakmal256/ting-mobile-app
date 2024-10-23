// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubit_tab_view/tab_view_cubit.dart';
import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:app/services/services.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../themes/themes.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with TickerProviderStateMixin {
  final picker = ImagePicker();

  var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.kMainGray),
      borderRadius: BorderRadius.circular(12));

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var image = File(pickedFile.path);

      var userLoginModel = context.read<ProfileBloc>().userLoginModel!;

      context.read<ProfileBloc>().add(ProfileImageUpdateEvent(
          imageFile: image, identityId: userLoginModel.loggedUser.identityId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadingSate) {
          EasyLoading.show();
        } else if (state is ProfileDataState) {
          EasyLoading.dismiss();
        } else if (state is ProfileErrorState) {
          EasyLoading.dismiss();
          context.read<ToastBloc>().add(MakeToastEvent(
              message: state.msg, context: context, inShell: false));
        } else if (state is ProfileUpdateSuccesState) {
          EasyLoading.show();
          context
              .read<ToastBloc>()
              .add(MakeToastEvent(message: "Updated!", context: context));
          context.read<ProfileBloc>().add(const FetchProfileDataEvent());
        } else if (state is ProfileVerifyState) {
          EasyLoading.dismiss();
          _verifyDialog(
            context,
            state.mob,
            state.email,
            state.fName,
            state.lName,
            state.dob,
            state.nic,
            state.model,
          );
        } else if (state is ProfilePasswordUpdateStates) {
          EasyLoading.dismiss();
          context.read<ToastBloc>().add(
              MakeToastEvent(message: "Password Updated!", context: context));
        } else if (state is ProfileBillingaddressState) {
          EasyLoading.dismiss();
        }
      },
      buildWhen: (previous, current) {
        if (current is ProfileDataState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: SingleChildScrollView(
                child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssestPath.assestBackgroundPath),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 70),
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () => context.go(AppRoutes.profile),
                            icon: const Icon(Icons.navigate_before,
                                color: Colors.white, size: 35))),
                    /* Blurred container */
                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Column(children: [
                              // tabbet widget

                              TabViewWidget(),

                              // user informatin form
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: BlocBuilder<TabViewCubit, TabViewState>(
                                  builder: (context, tabState) {
                                    return IndexedStack(
                                      index: context
                                              .read<TabViewCubit>()
                                              .state
                                              .position -
                                          1,
                                      children: [
                                        // profile overview
                                        ProfileOverviewWidget(
                                            outlineInputBorder:
                                                outlineInputBorder,
                                            tabState: tabState,
                                            user: state is ProfileDataState
                                                ? state.model
                                                : null),
                                        // account security
                                        AccountSecurityWidget(
                                            outlineInputBorder:
                                                outlineInputBorder,
                                            state: tabState),

                                        //Payment Details
                                        const PaymentDetailsWidget(),
// const SizedBox(),
                                        // Billing address
                                        BilingAddressTabScreen(
                                            userByEmailModel: context
                                                .read<ProfileBloc>()
                                                .userModel)
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ]),
                          ),
                          const SafeArea(child: SizedBox(height: 15)),
                        ],
                      ),
                    ),

                    /* Circle avatar image */
                    Positioned(
                      top: 0,
                      child: Column(
                        children: [
                          CircleAvatar(
                            minRadius: 50,
                            backgroundColor: AppColors.kGray2,
                            backgroundImage: CachedNetworkImageProvider(
                                state is ProfileDataState
                                    ? state.model.profilePictureUrl
                                    : ''),
                            child: state is ProfileImageLoadingState
                                ? const CircularProgressIndicator()
                                : null,
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size(120, 40),
                              backgroundColor: AppColors.kMainBlue,
                            ),
                            onPressed: () => pickImage(),
                            icon: const Icon(
                              Icons.mode_edit_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const CustomTextWidget(
                              text: 'Edit Photo',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            )),
          ),
        );
      },
    );
  }

  Future<void> _verifyDialog(
      BuildContext context,
      String mob,
      String email,
      String fName,
      String lName,
      String dob,
      String nic,
      IamUserModel model) async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return ConfirmMobileUpdateAlertDialog(
            dob: dob,
            email: email,
            fName: fName,
            lName: lName,
            mob: mob,
            model: model,
            nic: nic,
          );
        });
  }
}

// ignore: must_be_immutable
class TabViewWidget extends StatelessWidget {
  int position = 1;

  final List text = const [
    'Overview',
    'Account Security',
    'Payments Details',
    'Address',
  ];

  TabViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabViewCubit, TabViewState>(
      builder: (context, state) {
        position = context.read<TabViewCubit>().state.position;
        return SizedBox(
          height: 30,
          width: double.infinity,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: text.length,
            itemBuilder: (context, index) {
              int itemIndex = index + 1;
              return GestureDetector(
                onTap: () => context
                    .read<TabViewCubit>()
                    .setTabPosition(position: itemIndex),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: AppColors.kGray2,
                        borderRadius: BorderRadius.circular(20),
                        gradient: position == itemIndex
                            ? const LinearGradient(colors: [
                                AppColors.kMainOranage,
                                AppColors.kMainPink
                              ])
                            : null),
                    child: Center(
                        child: CustomTextWidget(
                      text: text[index],
                      fontSize: 12,
                      color: position == itemIndex
                          ? Colors.white
                          : AppColors.kMainBlue,
                      fontWeight: position == itemIndex
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ))),
              );
            },
          ),
        )

            // Container(
            //   width: double.infinity,
            //   height: 50,
            //   decoration: BoxDecoration(
            //       gradient: linearGradient,
            //       borderRadius: BorderRadius.circular(12)),
            //   child:
            //       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //     GestureDetector(
            //       onTap: () {
            //         context.read<TabViewCubit>().setTabPosition(position: 1);
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           gradient: index == 1 ? _linearGradient : null,
            //           borderRadius: const BorderRadius.only(
            //               topLeft: Radius.circular(12),
            //               bottomLeft: Radius.circular(12)),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 4, right: 4),
            //           child: TextWidget(index: index, text: text[0], position: 1),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: GestureDetector(
            //         onTap: () {
            //           context.read<TabViewCubit>().setTabPosition(position: 2);
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             gradient: index == 2 ? _linearGradient : null,
            //           ),
            //           child: TextWidget(index: index, text: text[1], position: 2),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: GestureDetector(
            //         onTap: () {
            //           context.read<TabViewCubit>().setTabPosition(position: 3);
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             gradient: index == 3 ? _linearGradient : null,
            //           ),
            //           child: TextWidget(index: index, text: text[2], position: 3),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: GestureDetector(
            //         onTap: () {
            //           context.read<TabViewCubit>().setTabPosition(position: 4);
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             gradient: index == 4 ? _linearGradient : null,
            //             borderRadius: const BorderRadius.only(
            //                 topRight: Radius.circular(12),
            //                 bottomRight: Radius.circular(12)),
            //           ),
            //           child: TextWidget(index: index, text: text[3], position: 4),
            //         ),
            //       ),
            //     ),
            //   ]),
            // )

            ;
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  final int index;

  final String text;
  final int position;
  const TextWidget(
      {super.key,
      required this.index,
      required this.text,
      required this.position});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: index == position
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomGradinetTextWidget(
                  text: text,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'RockfordSans'),
                  gradient: const LinearGradient(
                      colors: [AppColors.kMainOranage, AppColors.kMainPink]),
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'RockfordSans',
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ));
  }
}
