import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'add_new_complaint_selection.dart';

class OrderAndSupportScreen extends StatefulWidget {
  final int tabIndex;
  final String title;
  const OrderAndSupportScreen(
      {super.key, required this.tabIndex, required this.title});

  @override
  State<OrderAndSupportScreen> createState() => _OrderAndSupportScreenState();
}

class _OrderAndSupportScreenState extends State<OrderAndSupportScreen>
    with SingleTickerProviderStateMixin {
  List<String> tabs = [
    'Select order',
    'My complaints',
  ];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Adjust length based on tabs
    _tabController.animateTo(widget.tabIndex,
        duration: Duration.zero); // Select tab based on passed index
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          title: CustomTextWidget(
              text: widget.title, fontSize: 20, fontWeight: FontWeight.bold),
          bottom: TabBar(
              controller: _tabController,
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
        body: TabBarView(
            controller: _tabController,
            children: const [SelectOrderWidget(), MyComplaintsWidget()]),
      ),
    );
  }
}

class SelectOrderWidget extends StatelessWidget {
  const SelectOrderWidget({super.key});

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
              text: 'Completed Requests',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3),
          const SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Card(
                color: AppColors.kBlue1,
                child: SelectOrderCardWidget(
                  orderAmount: 10.00,
                  orderDateCompleted: "sdfsdf",
                  orderDateSubmitted: "sffdsd",
                  restaurantNames: ["KFC", "Nara Thai", "Pizza Hut"],
                  status: "Pending",
                ),
              ),
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

class SelectOrderCardWidget extends StatelessWidget {
  final List<String> restaurantNames;
  final String orderDateSubmitted;
  final String orderDateCompleted;
  final String status;
  final double orderAmount;

  const SelectOrderCardWidget({
    super.key,
    required this.restaurantNames,
    required this.orderDateSubmitted,
    required this.orderDateCompleted,
    required this.status,
    required this.orderAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              color: AppColors.kMainBlue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(AssestPath.orderIconPath),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4,
                ),
                ...restaurantNames.map((e) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                          text: "•  $e",
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 12,
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                    text: 'S1235555555 ',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPink3,
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                    text: 'S1235555555',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kGray2,
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AddNewComplaintSelection()));
                },
                style: ElevatedButton.styleFrom(
                    surfaceTintColor: AppColors.kBlue2,
                    backgroundColor: AppColors.kBlue2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24))),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                    text: 'Add',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class MyComplaintsWidget extends StatelessWidget {
  const MyComplaintsWidget({super.key});

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
              text: 'Completed Requests',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3),
          const SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Card(
                color: AppColors.kBlue1,
                child: MyComplaintCardWidget(
                  orderAmount: 10.00,
                  orderDateCompleted: "sdfsdf",
                  orderDateSubmitted: "sffdsd",
                  restaurantNames: ["KFC", "Nara Thai", "Pizza Hut"],
                  status: "Pending",
                ),
              ),
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

class MyComplaintCardWidget extends StatelessWidget {
  final List<String> restaurantNames;
  final String orderDateSubmitted;
  final String orderDateCompleted;
  final String status;
  final double orderAmount;

  const MyComplaintCardWidget({
    super.key,
    required this.restaurantNames,
    required this.orderDateSubmitted,
    required this.orderDateCompleted,
    required this.status,
    required this.orderAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(35, 197, 82, 1),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.0),
                    bottomLeft: Radius.circular(24.0))),
            width: 120.0,
            height: 25.0,
            child: const Center(
              child: Text(
                'New',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  color: AppColors.kMainBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(AssestPath.orderIconPath),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    ...restaurantNames.map((e) => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CustomTextWidget(
                              text: "•  $e",
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                        text: 'S1235555555 ',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPink3,
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          CustomTextWidget(
                            text: 'Submitted Date - 1 Jan  ',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kGray2,
                          ),
                          CustomTextWidget(
                            text: '| Completed Date - 3 Jan ',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kGray2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
