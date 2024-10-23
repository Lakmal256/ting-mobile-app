import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnSelect = void Function(String? name);

class CustomCategoriesScrollWidget extends StatefulWidget {
  const CustomCategoriesScrollWidget({
    super.key,
    required this.categoryList,
    required this.onSelect,
  });

  final List<CategoriesModel> categoryList;
  final OnSelect onSelect;

  @override
  State<CustomCategoriesScrollWidget> createState() =>
      _CustomCategoriesScrollWidgetState();
}

class _CustomCategoriesScrollWidgetState
    extends State<CustomCategoriesScrollWidget> {
  String? selectedName;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.5,
      child: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: widget.categoryList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (widget.categoryList[index].name == selectedName) {
                  selectedName = null;
                  widget.onSelect(null);
                  return;
                }
                selectedName = widget.categoryList[index].name;
                widget.onSelect(widget.categoryList[index].name);
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                          minRadius: 30,
                          backgroundColor:
                              widget.categoryList[index].name == selectedName
                                  ? AppColors.kBlue2.withOpacity(0.5)
                                  : AppColors.kBlue2,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CachedNetworkImage(
                                imageUrl: widget.categoryList[index].icon),
                          )),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                          text: widget.categoryList[index].name, fontSize: 16),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
