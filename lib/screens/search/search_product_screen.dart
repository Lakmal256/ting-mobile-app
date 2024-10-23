import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ViewSearchProductsScreen extends StatelessWidget {
  const ViewSearchProductsScreen({super.key, required this.model});

  final ProductsModel model;

  static const String id = 'view_search_products';

  @override
  Widget build(BuildContext context) {
// Default selected delivery fee
    double selectedRating = 3; // Default selected rating
    String selectedPrice = "\$"; // Default selected price
    List<String> selectedDietary = []; // Default selected price
    String selectedSort = ""; // Default selected sort

    // void showDeliveryFeeBottomSheet(BuildContext context) {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //         builder: (context, state) {
    //           return DeliveryFeeBottomSheet(
    //             selectedValue: selectedDeliveryFee,
    //             onChanged: (value) {
    //               // Update the selected delivery fee
    //               selectedDeliveryFee = value;
    //               state(() {});
    //             },
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    void showRatingBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return RatingBottomSheet(
                selectedValue: selectedRating,
                onChanged: (value) {
                  // Update the selected rating
                  selectedRating = value;
                  state(() {});
                },
              );
            },
          );
        },
      );
    }

    void showPriceBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return PriceBottomSheet(
                selectedValue: selectedPrice,
                onChanged: (value) {
                  // Update the selected price
                  selectedPrice = value;
                  state(() {});
                },
              );
            },
          );
        },
      );
    }

    void showDietaryBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return DietaryBottomSheet(
                selectedValues: selectedDietary,
                onChanged: (value) {
                  // Update the selected price
                  selectedDietary = value;
                  state(() {});
                },
              );
            },
          );
        },
      );
    }

    void showSortBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SortBottomSheet(
                selectedValue: selectedSort,
                onChanged: (value) {
                  // Update the selected price
                  selectedSort = value;
                  state(() {});
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: const SafeArea(
          child: SingleChildScrollView(),
        ),
      ),
    );
  }
}

class RatingBottomSheet extends StatefulWidget {
  final double selectedValue;
  final ValueChanged<double> onChanged;

  const RatingBottomSheet(
      {Key? key, required this.selectedValue, required this.onChanged})
      : super(key: key);

  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Center(
              child: Text("Rating",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Over ${widget.selectedValue}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("3",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("3.5",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("4",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("4.5",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("5",
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
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: widget.selectedValue,
                onChanged: widget
                    .onChanged, // Use the onChanged callback from the parent
                min: 3,
                max: 5,
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
                  onPressed: () {}, width: 340, height: 40, text: "Apply")),
          const SizedBox(height: 10),
          Center(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CustomGradinetTextWidget(text: "Cancel"))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class PriceBottomSheet extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const PriceBottomSheet(
      {Key? key, required this.selectedValue, required this.onChanged})
      : super(key: key);

  @override
  _PriceBottomSheetState createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<PriceBottomSheet> {
  String selectedOption = ""; // Added property to keep track of selected option

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedValue; // Set initial selected option
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Center(
              child: Text("Price",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Under ${widget.selectedValue}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildPriceOption(
                  "\$",
                  selectedOption ==
                      "\$"), // Updated options with color condition
              buildPriceOption(
                  "\$\$",
                  selectedOption ==
                      "\$\$"), // Updated options with color condition
              buildPriceOption(
                  "\$\$\$",
                  selectedOption ==
                      "\$\$\$"), // Updated options with color condition
              buildPriceOption(
                  "\$\$\$\$",
                  selectedOption ==
                      "\$\$\$\$"), // Updated options with color condition
            ],
          ),
          const SizedBox(height: 25),
          Center(
              child: CustomGradientFilterButton(
                  onPressed: () {}, width: 340, height: 40, text: "Apply")),
          const SizedBox(height: 10),
          Center(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CustomGradinetTextWidget(text: "Cancel"))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildPriceOption(String option, bool isSelected) {
    return Container(
      height: 25,
      width: 70,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : Colors.white.withOpacity(0.3), // Set color based on selection
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
      child: InkWell(
        onTap: () {
          // Update selected option and notify the parent
          selectedOption = option;
          widget.onChanged(option);
          setState(() {});
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomTextWidget(
            text: option,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.black
                : Colors.white, // Set text color based on selection
          ),
        ),
      ),
    );
  }
}

class DietaryBottomSheet extends StatefulWidget {
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;

  const DietaryBottomSheet(
      {Key? key, required this.selectedValues, required this.onChanged})
      : super(key: key);

  @override
  _DietaryBottomSheetState createState() => _DietaryBottomSheetState();
}

class _DietaryBottomSheetState extends State<DietaryBottomSheet> {
  late List<String>
      selectedOptions; // Use late initialization for better null safety

  @override
  void initState() {
    super.initState();
    selectedOptions = List.from(
        widget.selectedValues); // Initialize with the provided selected values
  }

  void applyChanges() {
    // Save selected options and notify the parent
    widget.onChanged(selectedOptions);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Center(
              child: Text("Dietary",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDietaryOption("Vegetarian"),
              buildDietaryOption("Non-Vegetarian"),
              buildDietaryOption("Vegan"),
              buildDietaryOption("Halal"),
            ],
          ),
          const SizedBox(height: 25),
          Center(
              child: CustomGradientFilterButton(
                  onPressed: applyChanges,
                  width: 340,
                  height: 40,
                  text: "Apply")),
          const SizedBox(height: 10),
          Center(
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CustomGradinetTextWidget(text: "Cancel"))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildDietaryOption(String option) {
    bool isSelected = selectedOptions.contains(option);

    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value != null) {
                if (value) {
                  selectedOptions.add(option); // Add the selected option
                } else {
                  selectedOptions
                      .remove(option); // Remove the unselected option
                }
              }
            });
          },
          activeColor: Colors.white,
          checkColor: AppColors.kBlue2,
          // visualDensity: VisualDensity.adaptivePlatformDensity, // Adjusts the space around the checkbox
          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // Removes extra padding
          side: const BorderSide(color: Colors.white),
        ),
        CustomTextWidget(
          text: option,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ],
    );
  }
}

class SortBottomSheet extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const SortBottomSheet(
      {Key? key, required this.selectedValue, required this.onChanged})
      : super(key: key);

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedValue; // Initialize selectedOption
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Center(
              child: Text("Sort",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSortOption("Recommended"),
              buildSortOption("Top Rated"),
              buildSortOption("Lower to highest price"),
              buildSortOption("High to lowest price"),
              buildSortOption("Preparation time"),
            ],
          ),
          const SizedBox(height: 25),
          Center(
              child: CustomGradientFilterButton(
                  onPressed: () {
                    widget.onChanged(selectedOption);
                    Navigator.pop(context);
                  },
                  width: 340,
                  height: 40,
                  text: "Apply")),
          const SizedBox(height: 10),
          Center(
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CustomGradinetTextWidget(text: "Cancel"))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildSortOption(String option) {
    return Row(
      children: [
        Radio(
          value: option,
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value.toString();
            });
          },
          activeColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          toggleable: true,
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        CustomTextWidget(
          text: option,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ],
    );
  }
}
