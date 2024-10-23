import 'dart:developer';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CardDetailsWidget(index: index);
          },
        ),
        const SizedBox(height: 20),
        CustomTransperantGradientButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: AppColors.kMainBlue,
                  child: CreditCardView(),
                );
              },
            );
          },
          width: double.infinity,
          height: 45,
          text: "Add new card",
          isIcon: true,
        )
      ],
    );
  }
}

class CreditCardView extends StatefulWidget {
  const CreditCardView({
    super.key,
  });

  @override
  State<CreditCardView> createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomTextWidget(
                text: "Add New Card",
                fontSize: 20,
                fontWeight: FontWeight.bold),
            CreditCardForm(
              formKey: formKey, // Required
              cardNumber: cardNumber, // Required
              expiryDate: expiryDate, // Required
              cardHolderName: cardHolderName, // Required
              cvvCode: cvvCode, // Required
              onCreditCardModelChange: onCreditCardModelChange, // Required
              obscureCvv: true,
              obscureNumber: false,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cvvValidationMessage: 'Please input a valid CVV',
              dateValidationMessage: 'Please input a valid date',
              numberValidationMessage: 'Please input a valid number',
              cardNumberValidator: (String? cardNumber) {
                if (cardNumber == null || cardNumber.isEmpty) {
                  return 'Please enter a card number';
                }

                final visaPattern = RegExp(r'^4[0-9]{3}(?:-[0-9]{4}){3}$');
                final mastercardPattern = RegExp(
                    r'^5(?:[1-5][0-9]{14}|2(?:22[1-9]|2[3-8][0-9]|29[01]|7[0-1][0-9]|720))[0-9]{12}$');

                if (visaPattern.hasMatch(cardNumber) ||
                    mastercardPattern.hasMatch(cardNumber)) {
                  log("Card : Matched");
                  return null;
                }

                log("Card : Not Matched");
                return 'Please enter a valid card number';
              },
              expiryDateValidator: (String? expiryDate) {
                return null;
              },
              cvvValidator: (String? cvv) {
                return null;
              },
              cardHolderValidator: (String? cardHolderName) {
                return null;
              },
              onFormComplete: () {},
              autovalidateMode: AutovalidateMode.onUserInteraction,
              disableCardNumberAutoFillHints: false,
              inputConfiguration: InputConfiguration(
                cardNumberDecoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: "Card number",
                    fillColor: AppColors.kMainGray,
                    hintStyle: CustomTextStyles.textStyleWhite_14,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                expiryDateDecoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: "MM / YY",
                    fillColor: AppColors.kMainGray,
                    hintStyle: CustomTextStyles.textStyleWhite_14,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                cvvCodeDecoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: "CVC",
                    fillColor: AppColors.kMainGray,
                    hintStyle: CustomTextStyles.textStyleWhite_14,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                cardHolderDecoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: "Card holder’s name",
                    fillColor: AppColors.kMainGray,
                    hintStyle: CustomTextStyles.textStyleWhite_14,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                cardNumberTextStyle: CustomTextStyles.textStyleWhiteMedium_12,
                cardHolderTextStyle: CustomTextStyles.textStyleWhiteMedium_12,
                expiryDateTextStyle: CustomTextStyles.textStyleWhiteMedium_12,
                cvvCodeTextStyle: CustomTextStyles.textStyleWhiteMedium_12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      onPressed: () => context.pop(),
                      textWidget: const CustomTextWidget(
                        text: "Cancel",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: _onValidate,
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.infinity, 40),
                            backgroundColor: AppColors.kBlue2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const CustomTextWidget(
                          text: "Save",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
    });
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.textWidget,
    required this.onPressed,
  });

  final Widget textWidget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.kMainOranage.withOpacity(0.5),
              AppColors.kMainPink.withOpacity(0.5)
            ]),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            child: textWidget));
  }
}

class CardDetailsWidget extends StatelessWidget {
  const CardDetailsWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    var cardIndex = index + 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        endActionPane: const ActionPane(motion: BehindMotion(), children: [
          SlidableAction(
            backgroundColor: AppColors.kBlue2,
            onPressed: null,
            icon: Icons.delete_rounded,
          ),
          SlidableAction(
            backgroundColor: AppColors.kBlue2,
            foregroundColor: Colors.white,
            label: "Edit",
            spacing: 0,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10)),
            onPressed: null,
            icon: Icons.edit,
          )
        ]),
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                AppColors.kMainOranage.withOpacity(0.6),
                AppColors.kMainPink.withOpacity(0.6)
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextWidget(
                text: "Card 0$cardIndex",
                fontSize: 14,
                color: Colors.black,
              ),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomTextWidget(
                  text: "XXXX - XXXX - XXXX - 2222",
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomTextWidget(
                  text: "Card Holder Name : William",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
