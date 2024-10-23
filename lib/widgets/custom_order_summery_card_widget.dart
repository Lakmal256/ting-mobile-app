// ignore_for_file: must_be_immutable

import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/services/validation_service.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomOrderSummeryCardWidget extends StatelessWidget {
  CustomOrderSummeryCardWidget({
    super.key,
    required this.cart,
    required this.currency,
    required this.shippingCost,
  });
  final List<Cart> cart;
  final String currency;
  final double shippingCost;
  var itemTotal = 0.0;
  var discountTotal = 0.0;
  var taxTotal = 0.0;

  void calculateItemTotal({required List<Cart> cart}) {
    for (var cartItem in cart) {
      itemTotal += cartItem.shopTotal.toDouble();

      for (var discountItem in cartItem.discountList) {
        discountTotal += discountItem.amount.toDouble();
      }

      for (var taxItem in cartItem.taxList) {
        taxTotal += taxItem.amount.toDouble();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateItemTotal(cart: cart);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            AppColors.kMainOranage.withOpacity(0.5),
            AppColors.kMainPink.withOpacity(0.5)
          ])),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const CustomTextWidget(
            text: 'Order Summary',
            fontSize: 18,
            textDecoration: TextDecoration.underline,
            fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const CustomTextWidget(
              text: 'Items Total', fontSize: 16, fontWeight: FontWeight.normal),
          CustomTextWidget(
              text: ValidationService()
                  .formatPriceWithCurrency(itemTotal, currency),
              fontSize: 16,
              fontWeight: FontWeight.normal)
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomTextWidget(
                text: 'Delivery Charge',
                fontSize: 16,
                fontWeight: FontWeight.normal),
            CustomTextWidget(
                text: ValidationService()
                    .formatPriceWithCurrency(shippingCost, currency),
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomTextWidget(
                text: 'VAT', fontSize: 16, fontWeight: FontWeight.normal),
            CustomTextWidget(
                text: ValidationService()
                    .formatPriceWithCurrency(taxTotal, currency),
                fontSize: 16,
                fontWeight: FontWeight.normal)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomTextWidget(
                text: '(Discount/ Promo)',
                fontSize: 16,
                fontWeight: FontWeight.normal),
            CustomTextWidget(
                text:
                    "- ${ValidationService().formatPriceWithCurrency(discountTotal, currency)}",
                fontSize: 16,
                fontWeight: FontWeight.normal)
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    AppColors.kMainOranage,
                    AppColors.kMainPink
                  ]))),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(
                  flex: 1,
                  child: CustomTextWidget(
                    text: 'Total Payment',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: CustomTextWidget(
                      text: ValidationService().formatPriceWithCurrency(
                          (itemTotal + shippingCost + taxTotal) -
                              (discountTotal),
                          currency),
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ))
            ])
      ]),
    );
  }
}
