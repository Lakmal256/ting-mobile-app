import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomHeaderWidget extends StatefulWidget {
  const CustomHeaderWidget(
      {super.key,
      this.goBack = false,
      required this.buildContext,
      this.onChange});
  final bool goBack;
  final BuildContext buildContext;
  final Function()? onChange;

  @override
  State<CustomHeaderWidget> createState() => _CustomHeaderWidgetState();
}

class _CustomHeaderWidgetState extends State<CustomHeaderWidget> {
  @override
  void initState() {
    var location = context.read<CurrentLocationCubit>();
    location.getLocation(context: context);
    super.initState();
  }

  handlePop(BuildContext context) {
    // onChange
  }

  handleChange(BuildContext context) async {
    await context.push(AppRoutes.address);
    widget.onChange?.call();
  }

  @override
  Widget build(BuildContext context) {
    Address selectedAddress =
        context.read<CurrentLocationCubit>().selectedAddress;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      widget.goBack
          ? IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(widget.buildContext).pop(),
              icon: const Icon(Icons.navigate_before_outlined,
                  color: Colors.white, size: 40))
          : const SizedBox.shrink(),
      Image.asset(AssestPath.assestLogoPath, width: 115.0, fit: BoxFit.cover),
      const Spacer(),
      Row(
        children: [
          Semantics(
            label: "Location_selector_001",
            child: InkWell(
              onTap: () => handleChange(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.kGray2),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CustomTextWidget(
                                      text: selectedAddress.addressLine1,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: selectedAddress.city.isEmpty
                              ? '${selectedAddress.district}, ${selectedAddress.province}'
                              : '${selectedAddress.city}, ${selectedAddress.district}',
                          fontSize: 14,
                          textAlign: TextAlign.end,
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Image.asset(AssestPath.locationIcon, width: 20)
        ],
      ),
    ]);
  }
}
