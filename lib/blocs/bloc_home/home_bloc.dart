import 'dart:async';
import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/marketplace/banners_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MarketplaceRepository _marketplaceRepo = MarketplaceRepository();
  late List<VendorsModel> shopList;
  HomeBloc() : super(HomeBlocInitial()) {
    on<HomeFetchDataEvent>(_homeFetchDataEvent);
    on<HomeVendorFilterEvent>(_homeFilterEvent);
    on<HomeFilterByCategoryEvent>(_homeFilterByCategoryEvent);
  }

  FutureOr<void> _homeFetchDataEvent(
      HomeFetchDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      List<ShopTypeModel> shopTypeList =
          await _marketplaceRepo.getShopsType(); // get shop type list
      List<CategoriesModel> categoriesList =
          await _marketplaceRepo.getCategories(
              department: event.department); // get restuarant catgories
      // find shop type id of name equel to Restaurants in shopTypeList
      String? typeID = shopTypeList
          .firstWhere((element) => element.name == event.department)
          .id;

      shopList = await _marketplaceRepo.getNearbyVendors(
          address: event.address, shopTypeId: typeID);

      List<BannersModel> bannersList = await _marketplaceRepo.getAllBanners();

      emit(HomeDataFetchSuccess(
          shopTypeList: shopTypeList,
          categoriesList: categoriesList,
          vendorsList: shopList,
          bannersList: bannersList)); // emit success state
    } on DioException catch (e) {
      if (e.type is ResponseTimoutException) {
        emit(const HomeDateErrorState(errorMessage: 'Connection Time-Out!'));
      }
      emit(const HomeDateErrorState(errorMessage: 'Something went wrong!'));
    } catch (e) {
      log("fetch shop type faild $e");
      emit(HomeDateErrorState(errorMessage: '$e'));
    }
  }

  FutureOr<void> _homeFilterEvent(
      HomeVendorFilterEvent event, Emitter<HomeState> emit) {
    if (event.selectedFilterOptionsList.isEmpty) {
      emit(HomeDataFilterCleanState(filteredVendorsList: shopList));
    } else {
      for (var i = 0; i < event.selectedFilterOptionsList.length; i++) {
        switch (event.selectedFilterOptionsList[i].filterType) {
          case FilterType.promotions:
            emit(HomeDataFilterdState(
                filteredVendorsList: shopList
                    .where((element) => element.isFeatured == true)
                    .toList()));
            break;
          case FilterType.deliveryFee:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                final deliveryFee = element.deliveryFee ?? 79;
                final selectedValue =
                    double.parse(event.selectedFilterOptionsList[i].value);
                return selectedValue >= deliveryFee;
              }).toList(),
            ));
            break;
          case FilterType.deliveryTime:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                final deliveryTime = element.deliveryTime ?? 15;
                // Remove the non-numeric part of the string
                String cleanedInput = event.selectedFilterOptionsList[i].value
                    .replaceAll(RegExp(r'[^0-9\- ]'), '');
                // Split the string to get lower and higher values
                List<String> parts = cleanedInput.split('-');
                // Parse the values to double
                double lowerValue = double.parse(parts[0].trim());
                double higherValue = double.parse(parts[1].trim());

                return lowerValue <= deliveryTime &&
                    higherValue >= deliveryTime;
              }).toList(),
            ));
            break;
          case FilterType.distance:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                return false;
              }).toList(),
            ));
            break;
          case FilterType.openingHours:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                return false;
              }).toList(),
            ));
            break;
          case FilterType.topMerchant:
            emit(HomeDataFilterdState(
                filteredVendorsList: shopList
                    .where((element) => element.isRecommended == true)
                    .toList()));
            break;
          case FilterType.rating:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                final rating = element.rating ?? 5.0;
                final selectedValue =
                    double.parse(event.selectedFilterOptionsList[i].value);
                return rating >= selectedValue;
              }).toList(),
            ));
            break;
          case FilterType.price:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                final priceRange =
                    (element.priceRange ?? "1000 - 2000").toString().split('-');
                final filteredPriceRange =
                    event.selectedFilterOptionsList[i].value.split('-');
                return (double.parse(filteredPriceRange[0]) <=
                        double.parse(priceRange[0])) &&
                    (double.tryParse(filteredPriceRange[1]) == null
                        ? true
                        : double.parse(filteredPriceRange[1]) >=
                            double.parse(priceRange[1]));
              }).toList(),
            ));
            break;
          case FilterType.dietary:
            emit(HomeDataFilterdState(
              filteredVendorsList: shopList.where((element) {
                final filteredList =
                    event.selectedFilterOptionsList[i].value.split(',');

                return (element.isVegetarian &&
                        filteredList.contains('Vegetarian')) ||
                    (!element.isVegetarian &&
                        filteredList.contains('Non-Vegetarian')) ||
                    (element.isVegan && filteredList.contains('Vegan')) ||
                    (element.isHalal && filteredList.contains('Halal')) ||
                    (element.isGluten && filteredList.contains('Gluten-Free'));
              }).toList(),
            ));
            break;
          case FilterType.sort:
            shopList.sort((a, b) {
              final sort = event.selectedFilterOptionsList[i].value;

              // Sorting logic
              switch (sort) {
                case 'Recommended':
                  return a.isRecommended == b.isRecommended
                      ? 0
                      : (a.isRecommended ? -1 : 1);
                case 'Top Rated':
                  return (a.rating ?? 0).compareTo(b.rating ?? 0);
                case 'Low to highest Price':
                  return (a.priceRange ?? 0).compareTo(b.priceRange ?? 0);
                case 'High to lowest Price':
                  return (b.priceRange ?? 0).compareTo(a.priceRange ?? 0);
                case 'Preparation time':
                  return (a.prepareTime ?? 0).compareTo(b.prepareTime ?? 0);
              }
              return 0;
            });
            emit(HomeDataFilterdState(filteredVendorsList: shopList));
            break;
          default:
        }
      }
    }
  }

  FutureOr<void> _homeFilterByCategoryEvent(
      HomeFilterByCategoryEvent event, Emitter<HomeState> emit) {
    /// check category name not empty or null
    if (event.categoryName == null || event.categoryName == '') {
      emit(HomeDataFilterCleanState(filteredVendorsList: shopList));
    } else {
      ///  apply the selected category to list of shops and show it in ui
      emit(HomeDataFilterdState(
          filteredVendorsList:
              filterCategories(categoryName: event.categoryName!)));
    }
  }

  List<VendorsModel> filterCategories({required String categoryName}) {
    List<VendorsModel> list = shopList
        .where((element) =>
            element.vendorCategories.any((item) => item.name == categoryName))
        .toList();
    return list;
  }
}
