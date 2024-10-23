import 'dart:io';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/custom_checkbox_with_text_widget.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'add_new_complaint.dart';

class AddNewComplaintSelection extends StatefulWidget {
  const AddNewComplaintSelection({super.key});

  @override
  State<AddNewComplaintSelection> createState() =>
      _AddNewComplaintSelectionState();
}

class _AddNewComplaintSelectionState extends State<AddNewComplaintSelection> {
  final picker = ImagePicker();

  File? imageFile;

  ComplaintType? complaintType;

  // reactive form group
  final _form = FormGroup({
    'complainType': FormControl<String>(),
  });

  // primery complaint list
  final List<String> complainTypes = [
    "Vendor / Products",
    "Rider",
  ];

  final List<String> sampleVendors = [
    "KFC",
    "Nara Thai",
    "Bake and Take",
  ];

  final Map<String, List<String>> sampleItems = {
    "KFC": ['Chicken Bucker', 'Cheese Burger', 'Mojito'],
    "Nara Thai": ['Butter Chicken', 'Garlic Naan'],
    "Bake and Take": ['Donut Choculate']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.kMainBlue,
          centerTitle: false,
          leading: IconButton(
              onPressed: () => context.pop(context),
              icon: const Icon(Icons.navigate_before,
                  color: Colors.white, size: 35)),
          title: const CustomTextWidget(
              text: 'Add New Complaint',
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: _form,
            child: SizedBox(
              height: complaintType != ComplaintType.vendorProducts
                  ? MediaQuery.of(context).size.height - 200
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ReactiveDropdownField<String>(
                    key: const Key('complainType'),
                    formControlName: 'complainType',
                    hint: const CustomTextWidget(
                        text: 'Select Complaint Type',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    items: complainTypes
                        .map((String type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    style: CustomTextStyles.textStyleWhite_14,
                    dropdownColor: AppColors.kBlue1,
                    decoration: InputDecoration(
                        filled: true,
                        constraints: const BoxConstraints(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        fillColor: AppColors.kBlue1,
                        iconColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                    onChanged: (value) {
                      if (value.value.toString() == complainTypes[0]) {
                        setState(() {
                          complaintType = ComplaintType.vendorProducts;
                        });
                      } else {
                        setState(() {
                          complaintType = ComplaintType.rider;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  complaintType == ComplaintType.rider
                      ? const Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: RiderWidget(
                            id: "ABC-2550",
                            imageUrl:
                                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
                            name: "Harley Buttons",
                          ),
                        )
                      : const SizedBox(),
                  complaintType == ComplaintType.vendorProducts
                      ? const VendorWidget()
                      : const SizedBox(),
                  complaintType != ComplaintType.vendorProducts
                      ? const Spacer()
                      : const SizedBox(),
                  ReactiveFormConsumer(
                      key: const Key('next'),
                      builder: (context, form, _) {
                        return CustomGradientButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddNewComplaint()));
                            },
                            width: double.infinity,
                            height: 50,
                            text: "Next");
                      }),
                  SizedBox(
                    height:
                        complaintType != ComplaintType.vendorProducts ? 0 : 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ComplaintType {
  vendorProducts,
  rider,
}

class RiderWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String id;
  const RiderWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.kBlue2, // Dark purple color
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                imageUrl), // Use AssetImage if you have a local asset
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                id,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VendorWidget extends StatelessWidget {
  const VendorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextWidget(
            text: 'Select Vendor',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.kBlue3),
        CustomCheckboxWithTextWidget(
          text: 'KFC',
          textColor: AppColors.kMainOranage,
          onHandler: (val) {},
        ),
        CustomCheckboxWithTextWidget(
          text: 'Nara Thai',
          textColor: AppColors.kMainOranage,
          onHandler: (val) {},
        ),
        CustomCheckboxWithTextWidget(
          text: 'Bake and Take',
          textColor: AppColors.kMainOranage,
          onHandler: (val) {},
        ),
        const SizedBox(
          height: 40,
        ),
        const CustomTextWidget(
            text: 'Select Item',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.kBlue3),
        const SizedBox(
          height: 12,
        ),
        const SelectItemWidget(),
        const SelectItemWidget(),
        const SelectItemWidget(),
        const SelectItemWidget(),
      ],
    );
  }
}

class SelectItemWidget extends StatelessWidget {
  const SelectItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextWidget(
            text: 'KFC',
            fontSize: 12,
            color: AppColors.kMainGray,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CustomCheckboxWithTextWidget(
                    text: 'Chicken Bucker',
                    textColor: Colors.white,
                    onHandler: (val) {},
                  );
                }),
          ),
          const Divider(
            color: AppColors.kBlue1,
          )
        ],
      ),
    );
  }
}
