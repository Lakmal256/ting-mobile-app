import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../../themes/themes.dart';

class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({super.key});

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen>
    with SingleTickerProviderStateMixin {
  bool showCard = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeaderWidget(buildContext: context),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                        text: "Choose a payment option",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    ListTile(
                        onTap: () {},
                        dense: true,
                        splashColor: AppColors.kBlue1,
                        title:
                            const CustomTextWidget(text: 'Cash', fontSize: 14),
                        trailing: const Icon(Icons.radio_button_off,
                            color: Colors.grey)),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(color: Colors.white.withOpacity(0.2))),
                    ListTile(
                        onTap: () {
                          setState(() {
                            showCard = !showCard;
                          });
                        },
                        dense: true,
                        splashColor: AppColors.kBlue1,
                        title:
                            const CustomTextWidget(text: 'Card', fontSize: 14),
                        trailing: const Icon(Icons.radio_button_off,
                            color: Colors.grey)),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(color: Colors.white.withOpacity(0.2))),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible: showCard,
                      child: Column(children: [
                        const SizedBox(height: 15),
                        const CardInformationWidget(),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                AppColors.kMainOranage.withOpacity(0.1),
                                AppColors.kMainPink.withOpacity(0.1)
                              ]),
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          padding: EdgeInsets.zero,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {},
                              child: const CustomTextWidget(
                                text: "+ Add New Card",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class CardInformationWidget extends StatefulWidget {
  const CardInformationWidget({
    super.key,
  });

  @override
  State<CardInformationWidget> createState() => _CardInformationWidgetState();
}

class _CardInformationWidgetState extends State<CardInformationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  bool tapped = false;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tapped
              ? animationController.reverse()
              : animationController.forward();
          tapped = !tapped;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            border: const GradientBoxBorder(
              gradient: LinearGradient(
                  colors: [AppColors.kMainOranage, AppColors.kMainPink]),
              width: 4,
            ),
            gradient: LinearGradient(
                colors: tapped
                    ? [AppColors.kMainOranage, AppColors.kMainPink]
                    : [
                        AppColors.kMainOranage.withOpacity(0.2),
                        AppColors.kMainPink.withOpacity(0.2)
                      ]),
            borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextWidget(
              text: 'Card 01',
              fontSize: 12,
              color: tapped ? Colors.white : AppColors.kBlue3),
          const SizedBox(height: 10),
          const SizedBox(
            width: double.maxFinite,
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.centerLeft,
              child: CustomTextWidget(
                text: 'XXXX - XXXX - XXXX - 5555',
                fontSize: 25,
                textAlign: TextAlign.justify,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const CustomTextWidget(
              text: 'Card Holder Name: Johm',
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ]),
      ).animate(controller: animationController, autoPlay: false).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.07, 1.07),
          duration: 200.milliseconds),
    );
  }
}
