import 'package:app/services/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../themes/themes.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  static const id = "forget_screen";

  final TextEditingController mobileTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPassBloc, ForgetPassState>(
      listener: (context, state) {
        if (state is ForgetPasswordLoadingState) {
          EasyLoading.show();
        } else if (state is ForgetPasswordErrorState) {
          EasyLoading.dismiss();
          context.read<ToastBloc>().add(MakeToastEvent(
              message: state.message, context: context, inShell: false));
        } else if (state is GetOtpSuccessState) {
          EasyLoading.dismiss();
          context.pushNamed(AppRoutes.otp, pathParameters: {
            'number': mobileTextController.text,
            'isForget': 'true'
          });
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  child: SafeArea(
                      child: Container(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        // logo image
                        Image.asset(AssestPath.assestLogoPath, scale: 1),
                        const SizedBox(height: 10),
                        const CustomTextWidget(
                            text: "Your one ting for Everything.",
                            fontSize: 16),
                        const SizedBox(height: 60),
                        const CustomTextWidget(
                            text: "Let’s get you onboard!",
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 20),
                        // text field
                        TextFormField(
                            controller: mobileTextController,
                            style: CustomTextStyles.textStyleWhite_14,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                prefixIcon: const SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text("+ 94",
                                        style:
                                            CustomTextStyles.textStyleWhite_14),
                                  ),
                                ),
                                fillColor: AppColors.kMainGray,
                                hintText: "Enter mobile number",
                                hintStyle: CustomTextStyles.textStyleWhite_14,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        SizedBox(height: MediaQuery.sizeOf(context).width / 2),
                        // gradient button
                        CustomGradientButton(
                            onPressed: () {
                              buttonPressed(context);
                            },
                            width: double.infinity,
                            height: 50,
                            text: "Get OTP"),

                        const SizedBox(height: 20),
                        const CustomTextWidget(
                            text: "We will send you one time SMS message ",
                            fontSize: 12)
                      ],
                    )),
                  )),
                ),
              )),
        );
      },
    );
  }

  void buttonPressed(BuildContext context) {
    context
        .read<ForgetPassBloc>()
        .add(GetOtpEvent(mobileNumber: mobileTextController.text));
  }
}
