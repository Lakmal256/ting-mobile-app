import 'dart:async';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubit_current_location/current_location_cubit.dart';
import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class CustomSearchTextWidget extends StatefulWidget {
  const CustomSearchTextWidget({
    super.key,
    required this.tappable,
    required this.searchView,
    required this.currentSearchTerm,
  });

  final bool tappable;
  final SearchView? searchView;
  final String currentSearchTerm;
  @override
  State<CustomSearchTextWidget> createState() => _CustomSearchTextWidgetState();
}

class _CustomSearchTextWidgetState extends State<CustomSearchTextWidget> {
  bool tapped = false;
  bool typing = false;
  bool clearText = false;
  List<String> recentSearches = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    searchController = TextEditingController(
        text: widget.currentSearchTerm.isNotEmpty ? widget.currentSearchTerm : searchController.text);
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final recentList = prefs.getStringList('recentSearches');
    if (recentList != null) {
      recentSearches = recentList;
    }
  }

  void _saveRecentSearch(String searchTerm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedSearches = prefs.getStringList('recentSearches');
    if (savedSearches != null) {
      recentSearches = savedSearches;
    }
    // Remove the search term if it exists in the list
    recentSearches.removeWhere((element) => element == searchTerm);
    // Add the search term to the beginning of the list
    if (searchTerm.isNotEmpty) {
      recentSearches.insert(0, searchTerm);
    }
    // Limit the list to 4 items
    if (recentSearches.length > 4) {
      recentSearches.removeLast();
    }

    await prefs.setStringList('recentSearches', recentSearches);
  }

  @override
  void didUpdateWidget(CustomSearchTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (clearText) {
        searchController.clear();
        clearText = false;
      } else if (typing) {
        searchController.text = searchController.text.isNotEmpty ? searchController.text : widget.currentSearchTerm;
      } else {
        searchController.text = widget.currentSearchTerm.isNotEmpty ? widget.currentSearchTerm : '';
      }
    });
  }

  void showToast(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        useRootNavigator: true,
        builder: (BuildContext bc) {
          return const CustomToastMessangerToast(
              message: 'Please Enter a Product Name');
        });
  }

  @override
  Widget build(BuildContext context) {
    var location = context.read<CurrentLocationCubit>();
    location.getLocation(context: context);

    return GestureDetector(
      onTap: () {
        if (widget.tappable) {
          setState(() {
            tapped = !tapped;
          });
          context.read<SearchBloc>().add(SearchViewUpdateEvenet(
              view: tapped ? SearchView.recentView : SearchView.defultView));
        } else {
          context.go(AppRoutes.search);
        }
      },
      child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
              color: AppColors.kBlue1, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              widget.searchView == SearchView.resultView
                  ? GestureDetector(
                      onTap: () {
                        context.read<SearchBloc>().add(
                            const SearchViewUpdateEvenet(
                                view: SearchView.recentView));
                        setState(() {
                          clearText = true;
                        });
                      },
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22))
                  : const Icon(Icons.search, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              tapped ||
                      widget.searchView == SearchView.recentView ||
                      widget.searchView == SearchView.resultView
                  ? const SizedBox.shrink()
                  : const CustomTextWidget(text: 'Search', fontSize: 18),
              tapped ||
                      widget.searchView == SearchView.recentView ||
                      widget.searchView == SearchView.resultView
                  ? const SizedBox.shrink()
                  : const SizedBox(width: 8),
              tapped ||
                      widget.searchView == SearchView.recentView ||
                      widget.searchView == SearchView.resultView
                  ? const SizedBox.shrink()
                  : const AnimatedTextWidget(),
              tapped ||
                      widget.searchView == SearchView.recentView ||
                      widget.searchView == SearchView.resultView
                  ? Flexible(
                      flex: 1,
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              typing = true;
                            });
                          },
                          onFieldSubmitted: (value) {
                            if (value.isEmpty) {
                              showToast(context);
                            } else {
                              setState(() {
                                typing = true;
                              });
                              context.read<SearchBloc>().add(SearchProductEvent(
                                  keyword: searchController.text,
                                  address: location.selectedAddress));
                              _saveRecentSearch(searchController.text);
                              searchController = searchController;
                            }
                          },
                          controller: searchController,
                          autocorrect: false,
                          autofocus: true,
                          style: CustomTextStyles.textStyleWhite_14,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search))
                  : const SizedBox.shrink(),
              typing && widget.searchView == SearchView.recentView
                  ? GestureDetector(
                      onTap: () {
                        if (searchController.text.isEmpty) {
                          showToast(context);
                        } else {
                          context.read<SearchBloc>().add(SearchProductEvent(
                              keyword: searchController.text,
                              address: location.selectedAddress));
                          _saveRecentSearch(searchController.text);
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined,
                          color: Colors.white))
                  : const SizedBox.shrink(),
              if (widget.searchView == SearchView.resultView) ...[
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                    child:
                        const Icon(Icons.cancel_outlined, color: Colors.white))
              ]
            ],
          )),
    );
  }
}

class AnimatedTextWidget extends StatefulWidget {
  const AnimatedTextWidget({
    super.key,
  });
  @override
  State<AnimatedTextWidget> createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> {
  List<String> textList = [
    'Appetizers',
    'Liquors',
    'Breakfast Meals',
    'Lunch Meals',
    'Dinner Meals'
  ];
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % textList.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradinetTextWidget(
            text: textList[currentIndex],
            style: CustomTextStyles.textStyleGradientBold_15
                .copyWith(fontSize: 18))
        .animate()
        .fadeIn();
  }
}
