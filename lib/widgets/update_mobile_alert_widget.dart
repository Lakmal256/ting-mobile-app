import 'dart:async';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../data/data.dart';

class ConfirmMobileUpdateAlertDialog extends StatefulWidget {
  final String mob;
  final String email;
  final String fName;
  final String lName;
  final String dob;
  final String nic;
  final IamUserModel model;

  const ConfirmMobileUpdateAlertDialog(
      {super.key,
      required this.mob,
      required this.email,
      required this.fName,
      required this.lName,
      required this.dob,
      required this.model,
      required this.nic});

  @override
  State<ConfirmMobileUpdateAlertDialog> createState() =>
      _ConfirmMobileUpdateAlertDialogState();
}

class _ConfirmMobileUpdateAlertDialogState
    extends State<ConfirmMobileUpdateAlertDialog> {
  CountdownController coundownController = CountdownController();
  var otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileOtpTimerStartEvent());
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileOtpTimerStartState) {
          coundownController.start();
        }
      },
      buildWhen: (pre, current) {
        if (current is ProfileOtpTimerStartState) {
          return true;
        }
        if (current is ProfileOtpErrorState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: AppColors.kMainBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: BlurryContainer(
            blur: 5,
            height: MediaQuery.sizeOf(context).height / 2,
            width: double.infinity,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white.withOpacity(0.03),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomTextWidget(
                      text: "Verify it was you!",
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  CustomTextWidget(
                      text: "Verify the code sent to ${widget.mob}",
                      fontSize: 16.0,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 20),
                  // otp text field
                  Form(
                    key: formKey,
                    child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter OTP';
                          }
                          return null;
                        },
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        errorAnimationController: errorController,
                        pinTheme: PinTheme(
                          errorBorderColor: Colors.red,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldWidth: 40,
                          fieldHeight: 40,
                          activeFillColor: AppColors.kGray1,
                          activeColor: AppColors.kGray1,
                          inactiveColor: AppColors.kMainGray,
                          inactiveFillColor: AppColors.kMainGray,
                        ),
                        enableActiveFill: true,
                        enablePinAutofill: true),
                  ),

                  hasError
                      ? const Text('Please Enter Valid OTP!',
                          style: TextStyle(color: Colors.red))
                      : const SizedBox.shrink(),

                  const SizedBox(height: 20),
                  Countdown(
                    seconds: 45,
                    controller: coundownController,
                    build: (BuildContext context, double time) {
                      return CustomTextWidget(
                          text: "0.${time.toStringAsFixed(0)}",
                          fontSize: 20,
                          fontWeight: FontWeight.bold);
                    },
                    interval: 1.seconds,
                    onFinished: () {},
                  ),
                  // resend otp
                  TextButton(
                      onPressed: () async {
                        if (coundownController.isCompleted!) {
                          await AuthRepositories()
                              .initUpdateMobileReop(mobile: widget.mob);
                          coundownController.restart();
                        }
                      },
                      child: const CustomTextWidget(
                          text: "Resend OTP", fontSize: 16)),

                  const SizedBox(height: 15),

                  CustomGradientButton(
                      onPressed: () {
                        formKey.currentState!.validate();
                        if (otpController.text.isEmpty ||
                            otpController.text.length != 6) {
                          errorController!.add(ErrorAnimationType.shake);
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          var userLoginModel =
                              context.read<ProfileBloc>().userLoginModel!;

                          context.read<ProfileBloc>().add(VerifyOtpButtonEvent(
                              otp: otpController.text,
                              fName: widget.fName,
                              lName: widget.lName,
                              dob: widget.dob,
                              email: widget.email,
                              mob: widget.mob,
                              nic: widget.nic,
                              model: widget.model,
                              identityId:
                                  userLoginModel.loggedUser.identityId));

                          Navigator.of(context).pop();
                        }
                      },
                      width: double.infinity,
                      height: 50,
                      text: "Verify & Update"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
