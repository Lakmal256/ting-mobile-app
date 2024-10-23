import 'dart:async';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});
  static const String id = 'order_screen';

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              HeaderWithBackButtonWidget(),
              Expanded(flex: 1, child: Spacer()),
              Expanded(flex: 3, child: RiderInforCardWidget())
            ]),
            const SizedBox(height: 10),
            const CustomTextWidget(
                text: 'Order received',
                fontSize: 25,
                fontWeight: FontWeight.bold),
            const SizedBox(height: 15),
            // status progress bar
            const Row(
              children: [
                Expanded(child: OrderStatusProgressBar(animate: true)),
                SizedBox(width: 10),
                Expanded(child: OrderStatusProgressBar(animate: false)),
                SizedBox(width: 10),
                Expanded(child: OrderStatusProgressBar(animate: false)),
              ],
            ),
            const SizedBox(height: 30),
            // button
            Align(
                alignment: Alignment.centerLeft,
                child: CustomGradientButton(
                    onPressed: () {},
                    width: 150,
                    height: 44,
                    text: 'Track Order')),
            const SizedBox(height: 20),
            // item list
            const Expanded(
              flex: 0,
              child: ItemListBuilder(),
            ),
            const SizedBox(height: 15),
            // total price
            const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: FittedBox(
                      child: CustomTextWidget(
                          text: 'Total Price',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: FittedBox(
                        child: CustomTextWidget(
                            text: 'Rs. 12,100',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ))
                ]),
            const SizedBox(height: 10),
            // divider
            const Divider(height: 10, thickness: 5, color: AppColors.kMainGray),
            const SizedBox(height: 15),
            // order summery
            // const CustomOrderSummeryCardWidget(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: CustomTextWidget(
                            text: 'Total Payment',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      FittedBox(
                        child: CustomTextWidget(
                            text: 'Rs. 15,100',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.only(left: 30),
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: const FittedBox(
                        child: CustomTextWidget(
                            text: "Cancel Order",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            textDecoration: TextDecoration.underline,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}

class OrderStatusProgressBar extends StatefulWidget {
  const OrderStatusProgressBar({super.key, required this.animate});
  final bool animate;

  @override
  State<OrderStatusProgressBar> createState() => _OrderStatusProgressBarState();
}

class _OrderStatusProgressBarState extends State<OrderStatusProgressBar> {
  double value = 0.3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.animate ? _startAnimation() : null;
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        // Toggle value between 0.3 and 1.0
        value = value == 0.2 ? 1.0 : 0.2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedProgressBar(
      value: widget.animate ? value : 0.0,
      duration: const Duration(seconds: 1),
      gradient: const LinearGradient(
        colors: [
          AppColors.kMainOranage,
          AppColors.kMainPink,
          AppColors.kMainPink,
        ],
      ),
      backgroundColor: AppColors.kGray2,
    );
  }

  @override
  void dispose() {
    widget.animate ? _timer.cancel() : null;
    super.dispose();
  }
}

class ItemListBuilder extends StatelessWidget {
  const ItemListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: CircleAvatar(
                        maxRadius: 12,
                        backgroundImage: CachedNetworkImageProvider(
                            'https://www.namesnack.com/images/namesnack-fast-food-restaurant-business-names-4240x2832-20200915.jpeg?crop=4:3,smart&width=1200&dpr=2')),
                  ),
                  Flexible(
                      flex: 1,
                      child: FittedBox(
                        child: CustomTextWidget(text: "Big Mac", fontSize: 18),
                      )),
                  Spacer(flex: 3),
                  Flexible(
                      flex: 1,
                      child: FittedBox(
                        child:
                            CustomTextWidget(text: "Rs. 3,200", fontSize: 18),
                      )),
                ],
              ),
            ));
  }
}

class RiderInforCardWidget extends StatelessWidget {
  const RiderInforCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
              backgroundColor: AppColors.kMainBlue,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(child: Icon(Icons.verified_user)),
                    const SizedBox(height: 10),
                    const CustomTextWidget(text: 'User Name', fontSize: 20),
                    const SizedBox(height: 10),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(
                        onTap: () {
                          final Uri url =
                              Uri(scheme: 'tel', path: '0765713598');
                          launchUrl(url);
                        },
                        child: Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [
                                  AppColors.kMainOranage,
                                  AppColors.kMainPink
                                ])),
                            child: const Center(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.call_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  CustomTextWidget(text: 'Call', fontSize: 15)
                                ]))),
                      ),
                      const SizedBox(width: 10),
                      Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(colors: [
                                AppColors.kMainOranage,
                                AppColors.kMainPink
                              ])),
                          child: const Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                Icon(Icons.mail_outline, color: Colors.white),
                                SizedBox(width: 5),
                                CustomTextWidget(text: 'Message', fontSize: 15)
                              ])))
                    ])
                  ],
                ),
              ))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
            color: AppColors.kBlue2, borderRadius: BorderRadius.circular(15)),
        child: const Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: FittedBox(
                  child: CustomTextWidget(
                      text: 'Harley  -  ',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: FittedBox(
                    child: CustomTextWidget(text: 'WP ', fontSize: 10),
                  )),
              Expanded(
                flex: 2,
                child: FittedBox(
                  child: CustomTextWidget(
                      text: ' ABC  2550',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 0,
                child: FittedBox(
                  child: Icon(
                    Icons.phone_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: FittedBox(
                  child: CustomTextWidget(
                      text: '  077  123  4567 ',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
