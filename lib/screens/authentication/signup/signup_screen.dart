import 'package:app/services/app_routers.dart';
import 'package:go_router/go_router.dart';
import "package:intl/intl.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:app/blocs/blocs_exports.dart';

import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _checkValue = false;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var dobController = TextEditingController();
  var emailController = TextEditingController();
  var mobController = TextEditingController();
  var idController = TextEditingController();
  var passController = TextEditingController();
  var conPassController = TextEditingController();

  var finalformattedDate = '';
  AuthCredential? _credentials;

  //
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupActionState) {
          // navigate to verify otp
          /// make sure to isforget value is false.
          context.pushNamed(AppRoutes.otp,
              pathParameters: {'number': state.mob, 'isForget': 'false'});
        } else if (state is SignUpGoogleDataSuccessState) {
          EasyLoading.dismiss();
          setState(() {
            firstNameController.text = state.userDate.firstName;
            lastNameController.text = state.userDate.lastName;
            emailController.text = state.userDate.email;
            _credentials = state.userDate.credentials;
          });

          focusNode.requestFocus();
        } else {
          switch (state.status) {
            case SignUpStatus.failure:
              EasyLoading.dismiss();
              context.read<ToastBloc>().add(MakeToastEvent(
                  message: state.message, context: context, inShell: false));
              break;
            case SignUpStatus.success:
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              break;
            case SignUpStatus.loading:
              EasyLoading.show();
              break;
            default:
          }
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
                        padding: const EdgeInsets.only(left: 25, right: 25),
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
                                controller: firstNameController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "First name",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // last name
                              TextFormField(
                                focusNode: focusNode,
                                controller: lastNameController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Last name",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // dob text field
                              GestureDetector(
                                onTap: () async {
                                  await pickDobCalender(context);
                                },
                                child: TextFormField(
                                  controller: dobController,
                                  style: CustomTextStyles.textStyleWhite_14,
                                  keyboardType: TextInputType.datetime,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: AppColors.kMainGray,
                                      hintText: "Date of birth",
                                      suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: IconButton(
                                              iconSize: 26.0,
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: Colors.white))),
                                      prefix: const SizedBox(width: 10),
                                      hintStyle:
                                          CustomTextStyles.textStyleWhite_14,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // email text field
                              TextFormField(
                                controller: emailController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.emailAddress,
                                enabled: _credentials != null ? false : true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "E-mail",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // mobile text field
                              TextFormField(
                                controller: mobController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    prefixIcon: const SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: Text("+ 94",
                                            style: CustomTextStyles
                                                .textStyleWhite_14),
                                      ),
                                    ),
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Mobile number",
                                    counterText: '',
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // last name
                              TextFormField(
                                controller: idController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "NIC Number",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),

                              // pass text field
                              TextFormField(
                                obscureText: true,
                                controller: passController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Password",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              const SizedBox(height: 20),
                              // con pass text field
                              TextFormField(
                                obscureText: true,
                                controller: conPassController,
                                style: CustomTextStyles.textStyleWhite_14,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kMainGray,
                                    hintText: "Confirm Password",
                                    prefix: const SizedBox(width: 10),
                                    hintStyle:
                                        CustomTextStyles.textStyleWhite_14,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),

                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _checkValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkValue = !_checkValue;
                                      });
                                    },
                                    fillColor:
                                        MaterialStateProperty.all(Colors.white),
                                    checkColor: AppColors.kMainBlue,
                                  ),
                                  const CustomTextWidget(
                                      text: "Term & Conditions", fontSize: 14)
                                ],
                              ),
                              const SizedBox(height: 15),

                              // gradient button
                              CustomGradientButton(
                                  onPressed: () {
                                    regButtonPress();
                                  },
                                  width: double.infinity,
                                  height: 50.0,
                                  text: "Sign Up"),

                              const SizedBox(height: 30),
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
                                          context.read<SignupBloc>().add(
                                              SignUpGoogleActionButtonEvent());
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

  Future<void> pickDobCalender(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme:
                  const ColorScheme.light(primary: AppColors.kMainBlue)),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        finalformattedDate = '${formattedDate}T00:00:00Z'; // Add time part
        dobController.text = formattedDate.toString();
      });
    }
  }

  SizedBox divider(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width / 2 - 100,
        child: const Divider(color: Colors.white, height: 3.0, thickness: 0.7));
  }

  void regButtonPress() async {
    context.read<SignupBloc>().add(SignupButtonPressEvent(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        dob: finalformattedDate,
        email: emailController.text,
        mobile: mobController.text,
        nic: idController.text,
        password: passController.text,
        conPassword: conPassController.text,
        isChecked: _checkValue,
        credentials: _credentials));
  }
}
