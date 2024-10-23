// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/custom_checkbox_with_text_widget.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FilterItemModel {
  final String name;
  final String iconPath;

  FilterItemModel({required this.name, required this.iconPath});
}

typedef OnValue = void Function(
    List<FilterDataModel> selectedFilterOptionsList);

class CustomFilterWidget extends StatefulWidget {
  final OnValue selectedFilterOptionsList;

  const CustomFilterWidget(
      {super.key, required this.selectedFilterOptionsList});

  @override
  State<CustomFilterWidget> createState() => _CustomFilterWidgetState();
}

class _CustomFilterWidgetState extends State<CustomFilterWidget> {
  List<FilterItemModel> itemList = [
    FilterItemModel(name: "Promotions", iconPath: AssestPath.assetPromotion),
    FilterItemModel(
        name: "Delivery Fee", iconPath: AssestPath.assetDeliveryFee),
    FilterItemModel(
        name: "Delivery Time", iconPath: AssestPath.assetDeliveryTime),
    FilterItemModel(name: "Distance", iconPath: AssestPath.assetDistance),
    FilterItemModel(
        name: "Opening Hours", iconPath: AssestPath.assetOpeningHours),
    FilterItemModel(
        name: "Top Merchant", iconPath: AssestPath.assetTopMerchant),
    FilterItemModel(name: "Rating", iconPath: AssestPath.assetRating),
    FilterItemModel(name: "Price", iconPath: AssestPath.assetPrice),
    FilterItemModel(
        name: "Dietary Preferences", iconPath: AssestPath.assetDietary),
    FilterItemModel(name: "Sort", iconPath: AssestPath.assetSort),
  ];

  List<FilterType> selectedItemList = []; // this is for adding selected items
  List<FilterDataModel> selectedFilterOptionsList = [];

  Future<void> showBottomSheet(
      {required BuildContext context,
      required int index,
      required Widget widget}) async {
    final result = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.kBlue1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.kGray2.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: const Center(
                                child: Icon(Icons.arrow_drop_down_outlined,
                                    color: Colors.white))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget,
                    const SizedBox(height: 10)
                  ],
                ));
          },
        );
      },
    );

    if (result != null) {
      log("Result: ${result.toString()}");
      setState(() {
        selectedFilterOptionsList.add(FilterDataModel(
            filterType: FilterType.values[index], value: result.toString()));
      });
    }
  }

  bool isFilterTypeSelected(FilterType filterType) {
    for (var filterData in selectedFilterOptionsList) {
      if (filterData.filterType == filterType) {
        return true;
      }
    }
    return false;
  }

  Future<void> handleSelection(int tappedIndex) async {
    if (isFilterTypeSelected(FilterType.values[tappedIndex])) {
      setState(() {
        selectedFilterOptionsList.removeWhere(
            (item) => item.filterType == FilterType.values[tappedIndex]);
      });
    } else {
      switch (FilterType.values[tappedIndex]) {
        case FilterType.promotions:
          setState(() {
            selectedFilterOptionsList.add(FilterDataModel(
                filterType: FilterType.values[tappedIndex], value: ''));
          });
          break;
        case FilterType.deliveryFee:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const DeliveryFeeSelector());

          break;
        case FilterType.deliveryTime:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const DeliveryTimeSelector());
          break;
        case FilterType.distance:
          setState(() {
            selectedFilterOptionsList.add(FilterDataModel(
                filterType: FilterType.values[tappedIndex], value: ''));
          });
          break;
        case FilterType.openingHours:
          setState(() {
            selectedFilterOptionsList.add(FilterDataModel(
                filterType: FilterType.values[tappedIndex], value: ''));
          });
          break;
        case FilterType.topMerchant:
          setState(() {
            selectedFilterOptionsList.add(FilterDataModel(
                filterType: FilterType.values[tappedIndex], value: ''));
          });
          break;
        case FilterType.rating:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const RatingSelector());
          break;
        case FilterType.price:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const PriceSelector());
          break;
        case FilterType.dietary:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const DietarySelector());
          break;
        case FilterType.sort:
          await showBottomSheet(
              context: context,
              index: tappedIndex,
              widget: const SortSelector());
          break;

        default:
      }
    }

    widget.selectedFilterOptionsList(selectedFilterOptionsList);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          double calculateContentWidth(String text, String icon) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              textDirection: TextDirection.ltr,
            )..layout();

            double textWidth = textPainter.width + 40;

            double iconWidth =
                icon.isNotEmpty ? 5.0 : 0.0; // Icon width + spacing

            return textWidth + iconWidth;
          }

          double totalWidth = calculateContentWidth(
              itemList[index].name, itemList[index].iconPath);
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              height: 50,
              width: totalWidth,
              decoration: BoxDecoration(
                color: isFilterTypeSelected(FilterType.values[index])
                    ? AppColors.kBlue3
                    : AppColors.kGray2,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
              child: InkWell(
                onTap: () {
                  handleSelection(index);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      itemList[index].iconPath,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                        text: itemList[index].name,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isFilterTypeSelected((FilterType.values[index]))
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DeliveryFeeSelector extends StatefulWidget {
  const DeliveryFeeSelector({super.key});

  @override
  _DeliveryFeeSelectorState createState() => _DeliveryFeeSelectorState();
}

class _DeliveryFeeSelectorState extends State<DeliveryFeeSelector> {
  double selectedDeliveryFee = 39;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Delivery Fee",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        if (selectedDeliveryFee == 79)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Any amount",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Under ${selectedDeliveryFee.round()}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("39",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text("52",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text("66",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text("79+",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 1,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              value: selectedDeliveryFee.round().toDouble(),
              onChanged: (value) {
                setState(() {
                  selectedDeliveryFee = value;
                });
              }, // Use the onChanged callback from the parent
              min: 39,
              max: 79,
              divisions: 3,
              activeColor: Colors.white,
              inactiveColor: AppColors.kGray2,
              thumbColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(context, selectedDeliveryFee);
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}

class RatingSelector extends StatefulWidget {
  const RatingSelector({super.key});

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  double selectedRating = 4.5;

  List<String> rating = ["3+", "3.5+", "4+", "4.5+", "5"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Rating",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Over $selectedRating",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(rating.length, (index) {
              return Text(rating[index],
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white));
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 1,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              value: selectedRating,
              onChanged: (value) {
                setState(() {
                  selectedRating = value;
                });
              }, // Use the onChanged callback from the parent
              max: 5,
              min: 3,
              divisions: 4,
              activeColor: Colors.white,
              inactiveColor: AppColors.kGray2,
              thumbColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(context, selectedRating);
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}

class DeliveryTimeSelector extends StatefulWidget {
  const DeliveryTimeSelector({super.key});

  @override
  State<DeliveryTimeSelector> createState() => _DeliveryTimeSelectorState();
}

class _DeliveryTimeSelectorState extends State<DeliveryTimeSelector> {
  String? _selectedTime;

  Widget _buildRadioOption(String time) {
    return RadioListTile<String>(
      value: time,
      groupValue: _selectedTime,
      onChanged: (String? value) {
        setState(() {
          _selectedTime = value;
        });
      },
      title: CustomTextWidget(
        text: time,
        fontSize: 15,
        textAlign: TextAlign.start,
      ),
      fillColor: WidgetStateProperty.all(Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Delivery Time",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        _buildRadioOption("10 - 20mins"),
        _buildRadioOption("20 - 30mins"),
        _buildRadioOption("30 - 45mins"),
        _buildRadioOption("45 - 60mins"),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(context, _selectedTime);
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}

class DietarySelector extends StatefulWidget {
  const DietarySelector({super.key});

  @override
  State<DietarySelector> createState() => _DietarySelectorState();
}

class _DietarySelectorState extends State<DietarySelector> {
  final List<String> _selectedDietaries = [];

  Widget _buildCheckBoxOption(String dietary) {
    return CustomCheckboxWithTextWidget(
        onHandler: (value) {
          if (value != null) {
            if (value) {
              _selectedDietaries.add(dietary);
            } else {
              _selectedDietaries.remove(dietary);
            }
          }
        },
        text: dietary,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Dietary",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        _buildCheckBoxOption("Vegetarian"),
        _buildCheckBoxOption("Non-Vegetarian"),
        _buildCheckBoxOption("Vegan"),
        _buildCheckBoxOption("Halal"),
        _buildCheckBoxOption("Gluten-Free"),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(
                      context, _selectedDietaries.join(',').toString());
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}

class SortSelector extends StatefulWidget {
  const SortSelector({super.key});

  @override
  State<SortSelector> createState() => _SortSelectorState();
}

class _SortSelectorState extends State<SortSelector> {
  String? _selectedSort;

  Widget _buildRadioOption(String time) {
    return RadioListTile<String>(
      value: time,
      groupValue: _selectedSort,
      onChanged: (String? value) {
        setState(() {
          _selectedSort = value;
        });
      },
      title: CustomTextWidget(
        text: time,
        fontSize: 15,
        textAlign: TextAlign.start,
      ),
      fillColor: WidgetStateProperty.all(Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Sort",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        _buildRadioOption("Recommended"),
        _buildRadioOption("Top Rated"),
        _buildRadioOption("Low to highest price"),
        _buildRadioOption("High to lowest price"),
        _buildRadioOption("Preparation time"),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(context, _selectedSort);
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}

class PriceSelector extends StatefulWidget {
  const PriceSelector({super.key});

  @override
  State<PriceSelector> createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PriceSelector> {
  int selectedRangeStart = 1000;
  int? selectedRangeEnd = 2000;

  Widget rangeButton(int start, int? end) {
    bool isSelected = (selectedRangeStart >= start &&
        (end == null || selectedRangeStart < end));
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRangeStart = start;
          selectedRangeEnd = end;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF6B5A9A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          end == null ? "$start+" : "$start-$end",
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text("Sort",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(height: 10),
        const Text(
          "Select Range",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            rangeButton(200, 1000),
            rangeButton(1000, 2000),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            rangeButton(2000, 3000),
            rangeButton(3000, null),
          ],
        ),
        const SizedBox(height: 15),
        Center(
            child: CustomGradientFilterButton(
                onPressed: () {
                  Navigator.pop(
                      context, '$selectedRangeStart - $selectedRangeEnd');
                },
                width: 340,
                height: 40,
                text: "Apply")),
        const SizedBox(height: 10),
        Center(
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CustomGradinetTextWidget(text: "Cancel"))),
        const SizedBox(height: 30),
      ],
    );
  }
}
