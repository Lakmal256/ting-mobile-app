import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kMainBlue,
        centerTitle: false,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.navigate_before,
                color: Colors.white, size: 35)),
        title: const CustomTextWidget(
            text: 'Notifications', fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          badges.Badge(
            badgeContent: Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              decoration: const BoxDecoration(
                  color: AppColors.kMainOranage,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: const CustomTextWidget(
                  text: '99+',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            position: badges.BadgePosition.topEnd(end: -15, top: 0),
            badgeAnimation: const badges.BadgeAnimation.fade(),
            badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.zero, badgeColor: Colors.transparent),
            child: SvgPicture.asset(AssestPath.notificationIcon, width: 30),
          ),
          const SizedBox(width: 30)
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomTextWidget(
                    text: 'Today',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kGray1),
                const SizedBox(height: 15),
                Expanded(
                    flex: 0,
                    child: ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => const NotificationCard(),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlue1,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5, right: 15),
                  child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(colors: [
                            AppColors.kMainOranage,
                            AppColors.kMainPink
                          ]).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      blendMode: BlendMode.srcIn,
                      child: const CircleAvatar(maxRadius: 8))),
            ),
            const Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: 'Notification discription',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4),
                    CustomTextWidget(
                      text: 'Order No: ',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ]),
            ),
            Expanded(
              flex: 0,
              child: Transform.scale(
                scale: 0.7,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
