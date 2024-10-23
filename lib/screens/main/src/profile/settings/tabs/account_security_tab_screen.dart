import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AccountSecurityWidget extends StatefulWidget {
  final OutlineInputBorder outlineInputBorder;

  final TabViewState state;
  const AccountSecurityWidget(
      {super.key, required this.outlineInputBorder, required this.state});

  @override
  State<AccountSecurityWidget> createState() => _AccountSecurityWidgetState();
}

class _AccountSecurityWidgetState extends State<AccountSecurityWidget> {
  var currentPasswordTextController = TextEditingController();

  var newPasswordTextController = TextEditingController();

  var conPasswordTextController = TextEditingController();
  bool currentPassVisible = true;
  bool newPassVisible = true;
  bool conPassVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.state.position == 2,
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const CustomGradinetTextWidget(
              text: 'Current password',
              style: CustomTextStyles.textStyleGradientBold_15),
          const SizedBox(height: 15),
          TextField(
              minLines: 1,
              obscureText: currentPassVisible,
              controller: currentPasswordTextController,
              style: CustomTextStyles.textStyleWhiteBold_12,
              decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: AppColors.kMainGray,
                  enabledBorder: widget.outlineInputBorder,
                  border: widget.outlineInputBorder,
                  focusedBorder: widget.outlineInputBorder,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPassVisible = !currentPassVisible;
                      });
                    },
                    child: Icon(
                      currentPassVisible
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ))),
          const SizedBox(height: 15),
          const CustomGradinetTextWidget(
              text: 'New password',
              style: CustomTextStyles.textStyleGradientBold_15),
          const SizedBox(height: 15),
          TextField(
              minLines: 1,
              obscureText: newPassVisible,
              controller: newPasswordTextController,
              style: CustomTextStyles.textStyleWhiteBold_12,
              decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: AppColors.kMainGray,
                  enabledBorder: widget.outlineInputBorder,
                  border: widget.outlineInputBorder,
                  focusedBorder: widget.outlineInputBorder,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        newPassVisible = !newPassVisible;
                      });
                    },
                    child: Icon(
                      newPassVisible
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ))),
          const SizedBox(height: 15),
          const CustomGradinetTextWidget(
              text: 'Re-enter new password',
              style: CustomTextStyles.textStyleGradientBold_15),
          const SizedBox(height: 15),
          TextField(
              minLines: 1,
              obscureText: conPassVisible,
              controller: conPasswordTextController,
              style: CustomTextStyles.textStyleWhiteBold_12,
              decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: AppColors.kMainGray,
                  enabledBorder: widget.outlineInputBorder,
                  border: widget.outlineInputBorder,
                  focusedBorder: widget.outlineInputBorder,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        conPassVisible = !conPassVisible;
                      });
                    },
                    child: Icon(
                      conPassVisible
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ))),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                    onPressed: () {
                      currentPasswordTextController.clear();
                      newPasswordTextController.clear();
                      conPasswordTextController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                        surfaceTintColor: AppColors.kPink1,
                        backgroundColor: AppColors.kPink1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const CustomTextWidget(
                      text: 'Cancel',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              const Expanded(flex: 1, child: SizedBox()),

              // update and save button
              Expanded(
                flex: 3,
                child: ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(
                        ProfileUpdatePasswordButtonEvent(
                            password: currentPasswordTextController.text,
                            newPassword: newPasswordTextController.text,
                            conPassword: conPasswordTextController.text)),
                    style: ElevatedButton.styleFrom(
                        surfaceTintColor: AppColors.kBlue2,
                        backgroundColor: AppColors.kBlue2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const CustomTextWidget(
                      text: 'Update & Save',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          ),
          const SizedBox(height: 15),
        ],
      )),
    );
  }
}
