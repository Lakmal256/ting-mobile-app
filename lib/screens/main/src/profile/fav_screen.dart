import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
            text: 'My Favorite', fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          Image.asset(AssestPath.favIcon, width: 35),
          const SizedBox(width: 20)
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTextWidget(
              text: 'Wish List',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.kBlue3,
            ),
            const SizedBox(height: 15),
            Expanded(
                child: ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                color: AppColors.kBlue1,
                child: AspectRatio(
                  aspectRatio: 10 / 3,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      'https://cdn.britannica.com/98/235798-050-3C3BA15D/Hamburger-and-french-fries-paper-box.jpg'),
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                const Expanded(
                                  flex: 0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: CustomTextWidget(
                                      text: 'Product Name',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    const CustomTextWidget(
                                      text: 'Nara Thai',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset(
                                      AssestPath.thumbesUpIcon,
                                      fit: BoxFit.cover,
                                      width: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    const CustomTextWidget(
                                      text: '45',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CustomTextWidget(
                                  text: ValidationService().formatPrice(3200),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(height: 10)
                              ])),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.white,
                                    )),
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(right: 5),
                                height: 25,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppColors.kMainOranage,
                                      AppColors.kMainPink
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(3),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: CustomTextWidget(
                                      text: "+  Add",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
