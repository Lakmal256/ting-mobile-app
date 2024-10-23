// ignore_for_file: must_be_immutable

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';

class SearchVendersFieldWidget extends StatelessWidget {
  SearchVendersFieldWidget(
      {super.key,
      required this.searchTextEditingController,
      required this.itemOnTap,
      required this.vendorList,
      required this.position});
  final TextEditingController searchTextEditingController;
  final void Function() itemOnTap;
  final List<VendorsModel> vendorList;
  final Position position;

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    return BlocBuilder<VendorsBloc, VendorsState>(
      buildWhen: (previouse, current) {
        if (current is SearchTextErrorState) {
          isError = true;
          return true;
        }

        return false;
      },
      builder: (context, state) {
        return Container(
          width: sizeOf.width / 2,
          height: 40,
          decoration: BoxDecoration(
              gradient: isError
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.kMainOranage, AppColors.kMainPink]),
              borderRadius: BorderRadius.circular(20),
              border: isError ? Border.all(color: Colors.red) : null),
          child: TypeAheadField<VendorsModel>(
            controller: searchTextEditingController,
            constraints: BoxConstraints(maxHeight: sizeOf.height / 3),
            suggestionsCallback: (search) {
              List<VendorsModel> list = vendorList
                  .where((vendor) =>
                      vendor.id.toLowerCase().contains(search.toLowerCase()))
                  .toList();
              // context
              //     .read<VendorsBloc>()
              //     .add(FilterVendorListEvent(filterdList: list));
              return list;
            },
            decorationBuilder: (context, widget) {
              return Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        AppColors.kMainOranage,
                        AppColors.kMainPink
                      ]),
                      borderRadius: BorderRadius.circular(15)),
                  child: widget);
            },
            builder: (context, controller, focusNode) {
              return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,
                  maxLines: 1,
                  style: CustomTextStyles.textStyleWhite_14,
                  onChanged: (value) {
                    // if (value.isEmpty) {
                    //   context
                    //       .read<VendorsBloc>()
                    //       .add(InitialVendorListEvent(position: position));
                    // }
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 5, bottom: 2),
                      border: InputBorder.none,
                      prefixIcon: GestureDetector(
                          onTap: itemOnTap,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(Icons.search,
                                color: isError ? Colors.red : Colors.white),
                          ))));
            },
            itemBuilder: (context, vendor) {
              return ListTile(
                dense: true,
                onTap: () {
                  // set name to controller
                  // searchTextEditingController.text = vendor.shopName;
                },
                title: CustomTextWidget(text: vendor.id, fontSize: 13),
              );
            },
            onSelected: (value) {},
          ),
        );
      },
    );
  }
}
