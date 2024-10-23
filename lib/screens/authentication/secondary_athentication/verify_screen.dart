// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/services/app_routers.dart';

import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen(
      {super.key, required this.mobNumber, required this.isForget});

  final String mobNumber;
  final bool isForget;

  static const id = 'verify_otp';

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  CountdownController coundownController = CountdownController();
  var otpController = TextEditingController();

  @override
  void initState() {
    context.read<OtpBloc>().add(OtpTimerStartEvent());
    super.initState();
  }

  void fetchUser(
      {required String identityId, required BuildContext context}) async {
    var read = context.read<ProfileBloc>();

    try {
      IamUserModel userModel =
          await AuthRepositories().userGetIamId(identity: identityId);
      read.userModel = userModel;
      EasyLoading.dismiss();
      // navigate to home
      context.go(AppRoutes.home);
    } on AuthException catch (e) {
      EasyLoading.dismiss();
      context.read<ToastBloc>().add(
          MakeToastEvent(message: e.message, context: context, inShell: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpErrorState) {
          EasyLoading.dismiss();
          context.read<ToastBloc>().add(MakeToastEvent(
              message: state.message, context: context, inShell: false));
        } else if (state is VerifyOtpSuccessState) {
          EasyLoading.dismiss();

          if (widget.isForget) {
            context.pushNamed(AppRoutes.updatePassword,
                pathParameters: {'code': state.authCode});
          } else {
            EasyLoading.show(status: 'Signing you in...');
            var read = context.read<SignupBloc>();
            context.read<OtpBloc>().add(SignInVerifiedUserEvent(
                email: read.email, pass: read.password));
          }
        } else if (state is OtpTimerStartState) {
          coundownController.start();
          EasyLoading.dismiss();
        } else if (state is AutomaticSignInSuccessState) {
          fetchUser(identityId: state.identityId, context: context);// navigate user to home
        } else if (state is AutomaticSignInFaillState) {
          EasyLoading.dismiss();
          context.read<ToastBloc>().add(MakeToastEvent(
              message: "Automatic sign-in failed.\nPlease sign in manually.",
              context: context));

          Future.delayed(3.seconds).whenComplete(() {
            context.go(AppRoutes.unauthorized);
          });
        } else if (state is OtpLoadingState) {
          EasyLoading.show();
        } else if (state is OtpSuccessState) {
          EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.kMainBlue,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssestPath.assestBackgroundPath),
                      fit: BoxFit.fill)),
              child: SafeArea(
                  child: Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // logo image
                    Image.asset(AssestPath.assestLogoPath, scale: 1),
                    //
                    const SizedBox(height: 10),
                    const CustomTextWidget(
                        text: "Your one ting for Everything.", fontSize: 16),
                    const SizedBox(height: 75),
                    const CustomTextWidget(
                        text: "Verify it was you!",
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                    const SizedBox(height: 5),
                    CustomTextWidget(
                        text: "Verify the code sent to ${widget.mobNumber}",
                        fontSize: 16.0,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                    const SizedBox(height: 20),
                    // otp text field
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldWidth: 45,
                        fieldHeight: 45,
                        activeFillColor: AppColors.kGray1,
                        activeColor: AppColors.kGray1,
                        inactiveColor: AppColors.kMainGray,
                        inactiveFillColor: AppColors.kMainGray,
                      ),
                      enableActiveFill: true,
                      enablePinAutofill: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width / 10),

                    BlocBuilder<OtpBloc, OtpState>(
                      builder: (context, state) {
                        if (state is OtpTimerStartState) {
                          coundownController.restart();
                        } else {
                          coundownController.onPause;
                        }
                        return Countdown(
                          seconds: 45,
                          controller: coundownController,
                          build: (BuildContext context, double time) =>
                              CustomTextWidget(
                                  text: "0.${time.toStringAsFixed(0)}",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                          interval: 1.seconds,
                          onFinished: () {
                            context
                                .read<OtpBloc>()
                                .add(OtpTimerFinishedEvent());
                          },
                        );
                      },
                    ),
                    // resend otp
                    ResendOtpButton(widget: widget, state: state),

                    SizedBox(height: MediaQuery.of(context).size.width / 5),

                    CustomGradientButton(
                        onPressed: () {
                          buttonPressed(context);
                        },
                        width: double.infinity,
                        height: 50,
                        text: "Verify"),
                  ],
                )),
              )),
            ),
          ),
        );
      },
    );
  }

  void buttonPressed(BuildContext context) {
    var readSignUp = context.read<SignupBloc>();
    widget.isForget
        ? context.read<OtpBloc>().add(OtpLoginVerifyEvent(
            mobile: widget.mobNumber, otp: otpController.text))
        : context.read<OtpBloc>().add(OtpVerifyEvenet(
            username: readSignUp.email,
            otp: otpController.text,
            applyResponseModel: readSignUp.model));
  }
}

class ResendOtpButton extends StatelessWidget {
  const ResendOtpButton({
    super.key,
    required this.widget,
    required this.state,
  });

  final VerifyOtpScreen widget;
  final OtpState state;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => state is OtpTimerFinishState
            ? context
                .read<OtpBloc>()
                .add(OtpSendEvent(username: widget.mobNumber))

            // widget.isForget
            //     ? context
            //         .read<OtpBloc>()
            //         .add(OtpSendEvent(username: widget.mobNumber))
            //     : context.read<OtpBloc>().add(OtpSignupResendEvent(
            //         model: context.read<SignupBloc>().model,
            //         signupButtonPressEvent:
            //             context.read<SignupBloc>().signupButtonEvent))
            : null,
        child: const CustomTextWidget(text: "Resend OTP", fontSize: 16));
  }
}
