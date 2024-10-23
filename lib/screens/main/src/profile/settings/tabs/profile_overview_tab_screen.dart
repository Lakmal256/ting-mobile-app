// ignore_for_file: must_be_immutable

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/data/models/models.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileOverviewWidget extends StatelessWidget {
  final OutlineInputBorder outlineInputBorder;

  final TabViewState tabState;
  final IamUserModel? user;
  ProfileOverviewWidget(
      {super.key,
      required this.outlineInputBorder,
      required this.tabState,
      required this.user});

  var firstNameTextController = TextEditingController();
  var lastNameTextController = TextEditingController();
  var dobTextController = TextEditingController();
  var emailTextController = TextEditingController();
  var nicTextController = TextEditingController();
  var mobTextController = TextEditingController();
  var provinceTextController = TextEditingController();

  var finalformattedDate = '';

  Future<void> pickDobCalender(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      const ColorScheme.light(primary: AppColors.kMainBlue)),
              child: child!);
        },
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(1800),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(
          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      final inputDate =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

      finalformattedDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(inputDate.toUtc());
      dobTextController.text = formattedDate.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      firstNameTextController.text = user!.firstName;
      lastNameTextController.text = user!.lastName;
      dobTextController.text = DateFormat('yyyy-MM-dd').format(user!.dob);
      nicTextController.text = user!.nic;
      emailTextController.text = user!.email;
      mobTextController.text = user!.mobile;
    }
    return Visibility(
      visible: tabState.position == 1,
      child: Form(
          child: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const CustomGradinetTextWidget(
                text: 'First name',
                style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            TextField(
                minLines: 1,
                controller: firstNameTextController,
                style: CustomTextStyles.textStyleWhiteBold_12,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.kMainGray,
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder)),
            const SizedBox(height: 15),
            const CustomGradinetTextWidget(
                text: 'Last name',
                style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            TextField(
                minLines: 1,
                controller: lastNameTextController,
                style: CustomTextStyles.textStyleWhiteBold_12,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.kMainGray,
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder)),
            const SizedBox(height: 15),
            const CustomGradinetTextWidget(
                text: 'Date of birth',
                style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                await pickDobCalender(context);
              },
              child: TextField(
                  minLines: 1,
                  controller: dobTextController,
                  style: CustomTextStyles.textStyleWhiteBold_12,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      enabled: false,
                      suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.calendar_today_outlined,
                              color: Colors.white)),
                      fillColor: AppColors.kMainGray,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder)),
            ),
            const SizedBox(height: 15),
            const CustomGradinetTextWidget(
                text: 'NIC', style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            TextField(
                minLines: 1,
                controller: nicTextController,
                style: CustomTextStyles.textStyleWhiteBold_12,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.kMainGray,
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder)),
            const SizedBox(height: 15),
            const CustomGradinetTextWidget(
                text: 'E-mail',
                style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            TextField(
                minLines: 1,
                controller: emailTextController,
                style: CustomTextStyles.textStyleWhiteBold_12,
                enabled: false,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.kMainGray,
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder)),
            const SizedBox(height: 15),
            const CustomGradinetTextWidget(
                text: 'Mobile number',
                style: CustomTextStyles.textStyleGradientBold_15),
            const SizedBox(height: 15),
            TextField(
                minLines: 1,
                controller: mobTextController,
                style: CustomTextStyles.textStyleWhiteBold_12,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.kMainGray,
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder)),
            // const SizedBox(height: 15),
            // CustomGradinetTextWidget(
            //     text: 'Province',
            //     style: CustomTextStyles.textStyleGradientBold_15),
            // const SizedBox(height: 15),
            // TextField(
            //     minLines: 1,
            //     controller: provinceTextController,
            //     style: CustomTextStyles.textStyleWhiteBold_12,
            //     decoration: InputDecoration(
            //         filled: true,
            //         isDense: true,
            //         fillColor: AppColors.kMainGray,
            //         enabledBorder: outlineInputBorder,
            //         border: outlineInputBorder,
            //         focusedBorder: outlineInputBorder)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      onPressed: () => context
                          .read<ProfileBloc>()
                          .add(const FetchProfileDataEvent()),
                      style: ElevatedButton.styleFrom(
                          surfaceTintColor: AppColors.kPink1,
                          backgroundColor: AppColors.kPink1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const CustomTextWidget(
                          text: 'Cancel',
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                ),
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      onPressed: () {
                        var userLoginModel =
                            context.read<ProfileBloc>().userLoginModel!;
                        return context.read<ProfileBloc>().add(
                            UpdateProfileButtonEvent(
                                fName: firstNameTextController.text,
                                lName: lastNameTextController.text,
                                dob: dobTextController.text,
                                nic: nicTextController.text,
                                email: emailTextController.text,
                                mob: mobTextController.text,
                                model: user!,
                                identityId:
                                    userLoginModel.loggedUser.identityId));
                      },
                      style: ElevatedButton.styleFrom(
                          surfaceTintColor: AppColors.kBlue2,
                          backgroundColor: AppColors.kBlue2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                          text: 'Update & Save',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ],
            ),
            // ignore: prefer_const_constructors
          ],
        ),
      )),
    );
  }
}
