import 'dart:io';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddNewComplaint extends StatefulWidget {
  const AddNewComplaint({super.key});

  @override
  State<AddNewComplaint> createState() => _AddNewComplaintState();
}

class _AddNewComplaintState extends State<AddNewComplaint> {
  final picker = ImagePicker();

  File? imageFile;

  // primery complaint list
  final List<String> complainTypes = [
    "Billing Issue",
    "Product Not Working Properly",
    "Damaged or Missing Product",
  ];

  // secoundry complaint type list
  final List<String> subComplainTypes = [
    "Payment Method Issues",
    "Incorrect/Faulty Product",
    "Missing/Damaged Accessories"
  ];

  // reactive form group
  final _form = FormGroup({
    'complainType': FormControl<String>(),
    'subComplainType': FormControl<String>(),
    'description': FormControl<String>(),
  });

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

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
            child: Column(
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
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                // sub complain drop down form feild
                ReactiveDropdownField<String>(
                  key: const Key('subComplainType'),
                  formControlName: 'subComplainType',
                  hint: const CustomTextWidget(
                      text: 'Select Complaint Sub Type',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  items: subComplainTypes
                      .map((String type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                  ),
                  style: CustomTextStyles.textStyleWhite_14,
                  dropdownColor: AppColors.kBlue1,
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      filled: true,
                      fillColor: AppColors.kBlue1,
                      iconColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 30),
                // additional feedback area
                ReactiveTextField(
                  key: const Key('description'),
                  formControlName: 'description',
                  maxLines: null,
                  maxLength: null,
                  minLines: 5,
                  style: CustomTextStyles.textStyleWhite_14
                      .copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: "Additional Feedback",
                      hintStyle: CustomTextStyles.textStyleWhite_14,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: AppColors.kBlue1,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 20),
                // attach image  button
                ElevatedButton.icon(
                  onPressed: () async {
                    await pickImage();
                  },
                  label: const CustomTextWidget(
                      text: 'Add Photo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  icon: const Icon(Icons.upload_outlined,
                      color: Colors.white, size: 15),
                  style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: AppColors.kBlue1),
                ),
                // show imageFile name
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        imageFile == null
                            ? ""
                            : imageFile!.path.split('/').last,
                        style: CustomTextStyles.textStyleWhiteBold_12,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    imageFile == null
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                imageFile = null;
                              });
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ))
                  ],
                ),

                const SizedBox(height: 20),

                ReactiveFormConsumer(
                    key: const Key('submit'),
                    builder: (context, form, _) {
                      return CustomGradientButton(
                          onPressed: () {},
                          width: double.infinity,
                          height: 50,
                          text: "Submit");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
