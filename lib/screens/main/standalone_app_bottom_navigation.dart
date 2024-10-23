import 'package:app/cubits/cubits.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/services/app_routers.dart';
import 'package:app/themes/themes.dart';

import '../../widgets/widgets.dart';
import 'package:badges/badges.dart' as badges;

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ToastBloc, ToastState>(
          listener: (context, state) {
            if (state is MakeToast) {
              showToast(context, state);
            }
          },
        ),
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoadedState) {
              context.read<NotificationContentCubit>().updateContent(
                  targetItem: AppRoutes.cart,
                  content: state.cartResModel!.items.length.toString());
            }
          },
        )
      ],
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          const Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: StandaloneAppBottomNavigation(),
          ),
        ],
      ),
    );
  }

  void showToast(BuildContext context, MakeToast state) {
    Future.delayed(2.5.seconds).whenComplete(() {
      Navigator.of(context).pop();
    });

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext bc) {
          return CustomToastMessangerToast(message: state.message);
        });
  }
}

class StandaloneAppBottomNavigation extends StatefulWidget {
  const StandaloneAppBottomNavigation({super.key});

  @override
  State<StandaloneAppBottomNavigation> createState() =>
      _StandaloneAppBottomNavigationState();
}

class _StandaloneAppBottomNavigationState
    extends State<StandaloneAppBottomNavigation> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(const FetchProfileDataEvent());
    super.initState();
  }

  String? handleBadgeText({required String pathName}) {
    var read = context.read<NotificationContentCubit>();
    var item =
        read.contentList.indexWhere((element) => element.item == pathName);

    if (item == -1) {
      return null;
    } else {
      var text = read.contentList[item].content;

      if (text == '0') return null;
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullPath = GoRouterState.of(context).fullPath;
    handleSelect(BuildContext context, String? routeName) {
      if (routeName == null) return;
      context.go(routeName);
    }

    return BlocBuilder<NotificationContentCubit, NotificationContentState>(
      builder: (context, state) {
        return AppBottomNavigation(
          children: [
            AppBottomNavigationIconItem(
              assest: AssestPath.homeIcon,
              selectedAssest: AssestPath.sHomeIcon,
              isSelected: AppRoutes.home == fullPath,
              onSelect: () => handleSelect(context, AppRoutes.home),
              badgeText: handleBadgeText(pathName: AppRoutes.home),
            ),
            AppBottomNavigationIconItem(
              assest: AssestPath.liquorIcon,
              selectedAssest: AssestPath.sLiquorIcon,
              isSelected: AppRoutes.liquor == fullPath,
              onSelect: () => handleSelect(context, AppRoutes.liquor),
              badgeText: handleBadgeText(pathName: AppRoutes.liquor),
            ),
            AppBottomNavigationIconItem(
              assest: AssestPath.searchIcon,
              selectedAssest: AssestPath.sSearchIcon,
              isSelected: AppRoutes.search == fullPath,
              onSelect: () => handleSelect(context, AppRoutes.search),
              badgeText: handleBadgeText(pathName: AppRoutes.search),
            ),
            AppBottomNavigationIconItem(
              assest: AssestPath.cartIcon,
              selectedAssest: AssestPath.sCartIcon,
              isSelected: AppRoutes.cart == fullPath,
              onSelect: () => handleSelect(context, AppRoutes.cart),
              badgeText: handleBadgeText(pathName: AppRoutes.cart),
            ),
            AppBottomNavigationIconItem(
              assest: AssestPath.profileIcon,
              selectedAssest: AssestPath.sProfileIcon,
              isSelected: AppRoutes.profile == fullPath,
              badgeText: handleBadgeText(pathName: AppRoutes.profile),
              onSelect: () async {
                context.read<ProfileBloc>().add(const FetchProfileDataEvent());

                return handleSelect(context, AppRoutes.profile);
              },
            ),
          ],
        );
      },
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.children});

  final List<Widget> children;

  Widget buildItem(BuildContext context, Widget child) {
    return FittedBox(
      fit: BoxFit.cover,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      padding: const EdgeInsets.only(bottom: 4),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        maintainBottomViewPadding: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: AppColors.kBlue2,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  children.map((item) => buildItem(context, item)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigationIconItem extends AppBottomNavigationItem {
  const AppBottomNavigationIconItem({
    super.key,
    required super.assest,
    required super.selectedAssest,
    required super.onSelect,
    super.isSelected,
    required super.badgeText,
  });
}

class AppBottomNavigationItem extends StatelessWidget {
  const AppBottomNavigationItem({
    super.key,
    required this.onSelect,
    this.isSelected = false,
    required this.assest,
    required this.badgeText,
    required this.selectedAssest,
  });

  final bool isSelected;

  final String assest;

  final String selectedAssest;
  final String? badgeText;

  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
        onTap: onSelect,
        behavior: HitTestBehavior.translucent,
        child: badges.Badge(
            showBadge: badgeText != null,
            badgeContent: badgeText != null
                ? Container(
                    decoration: const BoxDecoration(
                        color: AppColors.kMainOranage,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4))),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: CustomTextWidget(
                        text: badgeText!,
                        fontSize: 6,
                        fontWeight: FontWeight.bold))
                : null,
            badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.all(0), badgeColor: Colors.transparent),
            position: badges.BadgePosition.topEnd(top: 4, end: -10),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SvgPicture.asset(assest, width: 18))));

    if (isSelected) {
      child = Transform.scale(
        scale: 1.2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SvgPicture.asset(selectedAssest, width: 18),
        ),
      );
    }

    return child;
  }
}
