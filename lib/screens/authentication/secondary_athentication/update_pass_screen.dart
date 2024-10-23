// ignore_for_file: must_be_immutable

import 'package:app/cubits/cubit_update_pass/update_password_cubit.dart';
import 'package:app/services/app_routers.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/blocs_exports.dart';
import '../../../themes/themes.dart';

class UpdatePassScreen extends StatelessWidget {
  UpdatePassScreen({super.key, required this.authCode});
  final String authCode;

  static const id = 'update_pass';
  TextEditingController passwTextController = TextEditingController();
  TextEditingController confirmPasswTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePasswordCubit(),
      child: BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
        listener: (context, state) {

          if (state is ForgetPasswordLoadingState) {
            EasyLoading.show();
          } else if (state is UpdatePasswordErrorState) {
            EasyLoading.dismiss();
            context
                .read<ToastBloc>()
                .add(MakeToastEvent(message: state.message, context: context, inShell: false));
          } else if (state is UpdatePasswordSuccessState) {
            EasyLoading.dismiss();

            context.read<ToastBloc>().add(
                MakeToastEvent(message: "Password updated", context: context));

            Future.delayed(3.seconds).whenComplete(() {
              context.go(AppRoutes.unauthorized);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AssestPath.assestBackgroundPath),
                        fit: BoxFit.fill)),
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height,
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
                          text: "Change Password",
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 15),
                      // text field
                      TextFormField(
                          controller: passwTextController,
                          obscureText: true,
                          style: CustomTextStyles.textStyleWhite_14,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.kMainGray,
                              hintText: "Enter new password",
                              prefix: const SizedBox(width: 10),
                              hintStyle: CustomTextStyles.textStyleWhite_14,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      const SizedBox(height: 15),
                      // text field
                      TextFormField(
                          controller: confirmPasswTextController,
                          obscureText: true,
                          style: CustomTextStyles.textStyleWhite_14,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.kMainGray,
                              hintText: "Re-enter new password",
                              prefix: const SizedBox(width: 10),
                              hintStyle: CustomTextStyles.textStyleWhite_14,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      SizedBox(height: MediaQuery.sizeOf(context).width / 3),
                      // gradient button
                      CustomGradientButton(
                          onPressed: () {
                            context.read<UpdatePasswordCubit>().updateOnPressed(
                                password: passwTextController.text,
                                conpPassword: confirmPasswTextController.text,
                                token: authCode);
                          },
                          width: double.infinity,
                          height: 50,
                          text: "Update & Login"),
                    ],
                  )),
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
