// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/cubits/cubits.dart';
import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:app/services/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 15),
                const HeaderWidget(), // header
                const SizedBox(height: 20),
                CustomContainer(
                  name: "My Favorite",
                  path: AssestPath.favIcon,
                  showBadge: false,
                  notification: "10",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteScreen(),
                        ));
                  },
                ),
                CustomContainer(
                  name: "Notifications",
                  path: AssestPath.notificationIcon,
                  showBadge: true,
                  notification: "10",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ));
                  },
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SupportComplainsScreen())),
                          child: const CustomTextWidget(
                              text: "Support & Complains",
                              fontSize: 18,
                              color: AppColors.kBlue3)),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderScreen())),
                        child: const CustomTextWidget(
                            text: "My Orders",
                            fontSize: 18,
                            color: AppColors.kBlue3),
                      ),
                      TextButton(
                          onPressed: () async {
                            AuthHandler().signOut();
                            context.go(AppRoutes.unauthorized);
                          },
                          child: const CustomTextWidget(
                              text: "Log Out",
                              fontSize: 18,
                              color: AppColors.kMainOranage)),
                      const SafeArea(child: SizedBox(height: 10))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.onTap,
    required this.name,
    required this.path,
    required this.showBadge,
    this.notification = '',
  });

  final VoidCallback onTap;
  final String name;
  final String path;
  final bool showBadge;
  final String notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.kBlue1),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomTextWidget(
                      text: name, fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const Spacer(flex: 2),
            Align(
              alignment: Alignment.centerRight,
              child: NotificationBadge(
                show: showBadge,
                text: '10',
                iconPath: path,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.text,
    required this.show,
    required this.iconPath,
  });

  final String text;
  final bool show;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      showBadge: show,
      badgeContent: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: const BoxDecoration(
            color: AppColors.kMainOranage,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5))),
        child: CustomTextWidget(
            text: text,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      position: badges.BadgePosition.topEnd(end: -5, top: 0),
      badgeAnimation: const badges.BadgeAnimation.fade(),
      badgeStyle: const badges.BadgeStyle(
          padding: EdgeInsets.zero, badgeColor: Colors.transparent),
      child: iconPath.endsWith('.png')
          ? Image.asset(
              iconPath,
              width: 35,
              scale: 1,
            )
          : SvgPicture.asset(iconPath, width: 30),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<ProfileBloc>().userModel;
    return SafeArea(
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                context.read<TabViewCubit>().setTabPosition(position: 1);
                context.go(AppRoutes.settings);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CustomTextWidget(
                            text: userModel.firstName.isEmpty
                                ? "User Name"
                                : "${userModel.firstName} ${userModel.lastName}",
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1),
                      SvgPicture.asset(AssestPath.verifiedIcon,
                          fit: BoxFit.cover, width: 15)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                        text: userModel.addressList.isEmpty
                            ? "Welcome !"
                            : "${userModel.addressList.first.city}, ${userModel.addressList.first.district}",
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                context.read<TabViewCubit>().setTabPosition(position: 1);
                context.go(AppRoutes.settings);
              },
              child: FittedBox(
                child: CircleAvatar(
                  minRadius: 50,
                  backgroundColor: AppColors.kGray2,
                  backgroundImage: CachedNetworkImageProvider(
                    userModel.profilePictureUrl,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
    );
  }
}
