import 'dart:async';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'vendors_event.dart';
part 'vendors_state.dart';

class VendorsBloc extends Bloc<VendorsEvent, VendorsState> {
  final MarketplaceRepository _marketplaceRepository = MarketplaceRepository();
  late List<VendorsModel> vendors;
  late List<VendorsModel> vendorsResult;
  late VendorsModel selectedVendorModel;
  late ProductsModel productsResult;

  VendorsBloc() : super(VendorsInitial()) {
    on<VendorItemTapEvent>(_vendorItemTapEvent);
    on<VendorGetMenusEvent>(_vendorGetMenusEvent);
    on<VendorProductOnTapEvent>(_vendorProductOnTapEvent);
  }

  FutureOr<void> _vendorItemTapEvent(
      VendorItemTapEvent event, Emitter<VendorsState> emit) {
    selectedVendorModel = event.vendor;
  }

  FutureOr<void> _vendorGetMenusEvent(
      VendorGetMenusEvent event, Emitter<VendorsState> emit) async {
    emit(VendorLoadingState());
    VendorsMenuModel menuModel =
        await _marketplaceRepository.getVendorMenu(id: selectedVendorModel.id);
    VendorProfileModel profileModel =
        await _marketplaceRepository.getVendorProfile(
            id: selectedVendorModel.id,
            lat: selectedVendorModel.latitude.toString(),
            lon: selectedVendorModel.longitude.toString());

    emit(VendorGetMenuSuccessState(
        menuModel: menuModel, profileModel: profileModel));
  }

  FutureOr<void> _vendorProductOnTapEvent(
      VendorProductOnTapEvent event, Emitter<VendorsState> emit) async {
    emit(VendorLoadingState());
    try {
      ProductInfoModel prodcutInfoModel =
          await _marketplaceRepository.getProduct(id: event.productId);

      emit(VendorPorductViewState(prodcutInfoModel: prodcutInfoModel));
    } on DioException {
      emit(const VendorErrorState(error: "Product loading failed"));
    } catch (e) {
      emit(const VendorErrorState(error: "Product loading failed"));
    }
  }
}
