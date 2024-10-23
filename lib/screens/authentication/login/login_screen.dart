// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:app/cubits/cubits.dart';
import 'package:app/data/data.dart';
import 'package:app/services/app_routers.dart';

import 'package:app/themes/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:app/themes/app_colors.dart';
import 'package:app/themes/assest_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../blocs/blocs_exports.dart';
import '../../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var passwordTextController = TextEditingController();
  var emailTextController = TextEditingController();

  void fetchUser(
      {required String identityId, required BuildContext context}) async {
    var read = context.read<ProfileBloc>();

    try {
      IamUserModel userModel =
          await AuthRepositories().userGetIamId(identity: identityId);
      read.userModel = userModel;
      EasyLoading.dismiss();
      emailTextController.clear();
      passwordTextController.clear();

      /// navigate to home
      context.go(AppRoutes.authorized);
    } on AuthException catch (e) {
      EasyLoading.dismiss();
      context.read<ToastBloc>().add(
          MakeToastEvent(message: e.message, context: context, inShell: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<CurrentLocationCubit>().getLocation(context: context);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state.status) {
          case LoginStatus.failure:
            EasyLoading.dismiss();
            context.read<ToastBloc>().add(MakeToastEvent(
                message: state.message, context: context, inShell: false));
            break;
          case LoginStatus.success:
            log("Logi Success");
            fetchUser(identityId: state.message, context: context);
          case LoginStatus.loading:
            EasyLoading.show();
            break;
          default:
            EasyLoading.dismiss();

            context
                .read<ToastBloc>()
                .add(MakeToastEvent(message: state.message, context: context));
            emailTextController.clear();
            passwordTextController.clear();
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              // logo image
                              Image.asset(AssestPath.assestLogoPath, scale: 1),
                              //
                              const SizedBox(height: 10),
                              const CustomTextWidget(
                                  text: "Your one ting for Everything.",
                                  fontSize: 16),
                              const SizedBox(height: 75),

                              // email text field
                              TextFormField(
                                controller: emailTextController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Enter your email",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // password text field
                              TextFormField(
                                controller: passwordTextController,
                                obscureText: true,
                                style: CustomTextStyles.textStyleWhite_14,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Enter your password",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),

                              const SizedBox(height: 15),
                              TextButton(
                                  onPressed: () {
                                    context.push(AppRoutes.forgot);
                                  },
                                  child: const CustomTextWidget(
                                      text: "Forgot Password?",
                                      fontSize: 12.0)),

                              const SizedBox(height: 15),

                              // gradient button
                              CustomGradientButton(
                                  onPressed: () {
                                    loginButtonPress();
                                  },
                                  width: double.infinity,
                                  height: 50.0,
                                  text: "Log in"),

                              const SizedBox(height: 30),

                              // register navigation
                              RichText(
                                  text: const TextSpan(children: [
                                TextSpan(
                                    text: 'Don’t have an account?  ',
                                    style: CustomTextStyles
                                        .textStyleWhiteMedium_12)
                              ])),
                              const SizedBox(height: 20),

                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: const GradientBoxBorder(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.kMainOranage,
                                              AppColors.kMainPink,
                                            ],
                                          ),
                                          width: 2)),
                                  child: TextButton(
                                      onPressed: () =>
                                          context.push(AppRoutes.signup),
                                      child: CustomGradinetTextWidget(
                                        text: "Sign Up",
                                        style: CustomTextStyles
                                            .textStyleGradientBold_15
                                            .copyWith(fontSize: 18),
                                        gradient: const LinearGradient(colors: [
                                          AppColors.kMainOranage,
                                          AppColors.kMainPink
                                        ]),
                                      ))),

                              const SizedBox(height: 20),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    divider(context),
                                    const CustomTextWidget(
                                        text: "or connect with", fontSize: 12),
                                    divider(context)
                                  ]),
                              const SizedBox(height: 10),

                              // social login buttons
                              SizedBox(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // google login
                                    IconButton(
                                        onPressed: () {
                                          googleSignInButtonPress();
                                        },
                                        icon: Image.asset(
                                            AssestPath.assestGoogleIconPath)),
                                    // Facebook login
                                    IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                            AssestPath.assestFbIconPath))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        ))),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox divider(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width / 2 - 100,
        child: const Divider(color: Colors.white, height: 3.0, thickness: 0.7));
  }

  void loginButtonPress() {
    context.read<LoginBloc>().add(LoginButtonPressedEvent(
        email: emailTextController.text,
        password: passwordTextController.text));
  }

  void googleSignInButtonPress() {
    context
        .read<LoginBloc>()
        .add(const GoogleSigninButtonPressEvent(token: ''));
  }
}
