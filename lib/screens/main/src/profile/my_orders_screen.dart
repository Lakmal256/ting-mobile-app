import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  List<String> tabs = [
    'Ongoing Orders',
    'Past Orders',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const linearGradient =
        LinearGradient(colors: [AppColors.kMainOranage, AppColors.kMainPink]);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kMainBlue,
          centerTitle: false,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.navigate_before,
                  color: Colors.white, size: 35)),
          title: const CustomTextWidget(
              text: 'My Orders', fontSize: 20, fontWeight: FontWeight.bold),
          bottom: TabBar(
              labelPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              unselectedLabelStyle: CustomTextStyles.textStyleWhite_12,
              indicator: const ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 4.0,
                          style: BorderStyle.solid)),
                  gradient: linearGradient),
              tabs: tabs
                  .map((String tab) => Tab(
                      key: Key(tab),
                      child: Container(
                        color: AppColors.kMainBlue,
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: CustomTextWidget(
                              text: tab,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )))
                  .toList()),
        ),
        backgroundColor: AppColors.kMainBlue,
        body: const TabBarView(
            children: [OnGoingOrdersWidget(), PastOrdersWidget()]),
      ),
    );
  }
}

class OnGoingOrdersWidget extends StatelessWidget {
  const OnGoingOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const CustomTextWidget(
              text: 'Showing result of ongoing orders..',
              fontSize: 18,
              color: AppColors.kBlue3),
          const SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) => const Card(
              color: AppColors.kBlue1,
              child: OngoingOrderCardWidget(),
            ),
          )),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          )
        ],
      ),
    );
  }
}

class PastOrdersWidget extends StatefulWidget {
  const PastOrdersWidget({super.key});

  @override
  State<PastOrdersWidget> createState() => _PastOrdersWidgetState();
}

class _PastOrdersWidgetState extends State<PastOrdersWidget> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          showMore
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                        icon: const Icon(Icons.navigate_before,
                            color: AppColors.kGray2, size: 35)),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          text: '3 Jan 2024 - 1:16 PM',
                          fontSize: 18,
                          color: AppColors.kGray2,
                        ),
                        CustomTextWidget(
                          text: 'Order ID : S123456789',
                          fontSize: 12,
                          color: AppColors.kBlue3,
                        ),
                      ],
                    )
                  ],
                )
              : const CustomTextWidget(
                  text: 'Showing result of past orders..',
                  fontSize: 18,
                  color: AppColors.kBlue3,
                ),
          const SizedBox(height: 20),
          Expanded(
              flex: 0,
              child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => showMore
                      ? const PastOrdersCardWidget()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              showMore = !showMore;
                            });
                          },
                          child: const PastOrdersMainCardWidget()))),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          )
        ],
      ),
    );
  }
}

class PastOrdersCardWidget extends StatefulWidget {
  const PastOrdersCardWidget({super.key});

  @override
  State<PastOrdersCardWidget> createState() => _PastOrdersCardWidgetState();
}

class _PastOrdersCardWidgetState extends State<PastOrdersCardWidget> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlue1,
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: 0.5.seconds,
        child: AspectRatio(
          aspectRatio: showMore ? 4 / 6 : 10 / 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 10 / 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          elevation: 0.5,
                          color: AppColors.kGray2,
                          child: CustomNetworkImage(
                              imageUrl:
                                  'https://i.postimg.cc/tCgvbjsh/download-removebg-preview-1-1.png'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomTextWidget(
                                text: 'Shop Name - Location',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomTextWidget(
                              text: 'Date - Time',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kGray2,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomTextWidget(
                              text: 'Price - Quantity',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kGray2,
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          flex: 0,
                          child: Transform.scale(
                            scale: 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showMore = !showMore;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: AppColors.kBlue2),
                              child: showMore
                                  ? const Row(
                                      children: [
                                        CustomTextWidget(
                                            text: 'Less', fontSize: 12),
                                        Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  : const CustomTextWidget(
                                      text: 'More..', fontSize: 12),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: showMore,
                  maintainAnimation: true,
                  maintainState: true,
                  child: AnimatedOpacity(
                      duration: 1.seconds,
                      curve: Curves.slowMiddle,
                      opacity: showMore ? 1 : 0,
                      child: const MoreInformationWidget())),
              //
            ],
          ),
        ),
      ),
    );
  }
}

class PastOrdersMainCardWidget extends StatefulWidget {
  const PastOrdersMainCardWidget({super.key});

  @override
  State<PastOrdersMainCardWidget> createState() =>
      _PastOrdersMainCardWidgetState();
}

class _PastOrdersMainCardWidgetState extends State<PastOrdersMainCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlue1,
      child: AspectRatio(
        aspectRatio: 10 / 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Card(
                  child: SvgPicture.asset(
                    AssestPath.pastOrderIcon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                        text: 'S123456789',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                      text: '3 Jan - 1:16 PM',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kGray2,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                      text: 'Rs. 30,800.00 - 14 items',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kGray2,
                    ),
                  ),
                ],
              )),
              Expanded(
                  flex: 0,
                  child: Transform.scale(
                    scale: 0.8,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: AppColors.kBlue2),
                      child:
                          const CustomTextWidget(text: 'More..', fontSize: 12),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MoreInformationWidget extends StatelessWidget {
  const MoreInformationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: 'Orderd Items',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.kBlue3,
              ),
              CustomTextWidget(
                text: 'LKR price',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.kBlue3,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const CustomTextWidget(
              text: 'Sri Lanka Spicy Veg Pizza (1)', fontSize: 14),
          const CustomTextWidget(text: 'Garlic Bread (1)', fontSize: 14),
          const SizedBox(height: 20),
          const CustomTextWidget(
              text: 'Would you like this product',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3),
          const SizedBox(height: 10),
          const LikeButton(),
          const SizedBox(height: 20),
          const CustomTextWidget(
              text: 'Add feedback',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3),
          const SizedBox(height: 15),
          // additional feedback area
          TextFormField(
            key: const Key('description'),
            maxLines: null,
            maxLength: null,
            minLines: 5,
            style: CustomTextStyles.textStyleWhite_14,
            decoration: InputDecoration(
                hintText: "Additional Feedback",
                hintStyle: CustomTextStyles.textStyleWhite_14,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: AppColors.kMainBlue,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomGradientButton(
                onPressed: () {},
                width: double.infinity,
                height: 40,
                text: "Submit"),
          )
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.kMainBlue,
          borderRadius: BorderRadius.circular(20)),
      width: 120,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.thumb_up_alt_outlined,
            size: 24,
            color: AppColors.kBlue3,
          ),
          const CustomTextWidget(
              text: '50',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3),
          Container(
            height: 50,
            width: 1,
            color: AppColors.kGray1,
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: const Icon(
              Icons.thumb_down_alt_outlined,
              size: 24,
              color: AppColors.kBlue3,
            ),
          )
        ],
      ),
    );
  }
}

class OngoingOrderCardWidget extends StatelessWidget {
  const OngoingOrderCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 10 / 3,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Card(
                elevation: 0.5,
                color: AppColors.kGray2,
                child: CustomNetworkImage(
                    imageUrl:
                        'https://i.postimg.cc/tCgvbjsh/download-removebg-preview-1-1.png'),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                      text: 'Shop Name - Location',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                    text: 'Date - Time',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kGray2,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                    text: 'Price - Quantity',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kGray2,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
