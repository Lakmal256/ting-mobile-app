import 'dart:convert';
import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:app/data/models/checkout/checkout_model.dart';
import 'package:app/data/models/marketplace/banners_model.dart';
import 'package:dio/dio.dart';

class MarketplaceRepository {
  MarketplaceRepository() : _apiClient = MarketplaceApiClient();

  final MarketplaceApiClient _apiClient;

  Future<List<VendorsModel>> getNearbyVendors(
      {required Address address, required String shopTypeId}) async {
    List<VendorsModel> vendorList = await _apiClient.fetchNearbuyVenders(
        lon: address.longitude.toString(),
        lat: address.latitude.toString(),
        shopTypeId: shopTypeId);
    return vendorList;
  }

  Future<List<VendorsModel>> searchProductsByVendor(
      {required Address address, required String searchText}) async {
    List<VendorsModel> productsByVendor = await _apiClient
        .searchsProductsByVendor(address: address, searchText: searchText);
    return productsByVendor;
  }

  Future<ProductsModel> getProductsByShop({required String shopId}) async {
    ProductsModel products = await _apiClient.getProductsByShop(shopId: shopId);
    return products;
  }

  // Future<List<CategorizedProductModel>> getCategorizedProducts() async {
  //   List<CategorizedProductModel> filterdProducts = [];
  //   List<CategorizedProductModel> products =
  //       await _apiClient.getCategorizedProducts();

  //   for (var i = 0; i < products.length; i++) {
  //     if (products[i].productList.length >= 2) {
  //       filterdProducts.add(products[i]);
  //     }
  //   }
  //   return filterdProducts;
  // }

  Future<List<ShopTypeModel>> getShopsType() async {
    try {
      Response response = await _apiClient.getShopTypes();

      String jsonString = json.encode(response.data);

      List<ShopTypeModel> model = shopTypeFromJson(jsonString);
      return model;
    } on DioException {
      if (DioException is RequestFailureException) {
        throw Exception("Request Error");
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoriesModel>> getCategories(
      {required String department}) async {
    try {
      Response response =
          await _apiClient.getCategories(department: department);

      String jsonString = json.encode(response.data);

      List<CategoriesModel> model = categoriesModelFromJson(jsonString);

      return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<VendorsMenuModel> getVendorMenu({required String id}) async {
    try {
      Response response = await _apiClient.getVendorMenu(id: id);

      String jsonString = json.encode(response.data);

      VendorsMenuModel model = vendorsMenuModelFromJson(jsonString);

      return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<VendorProfileModel> getVendorProfile(
      {required String id, required String lat, required String lon}) async {
    try {
      Response response =
          await _apiClient.getVendorProfile(id: id, lat: lat, lon: lon);

      String jsonString = json.encode(response.data);

      VendorProfileModel model = vendorProfileModelFromJson(jsonString);

      return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductInfoModel> getProduct({required String id}) async {
    try {
      Response response = await _apiClient.getProduct(id: id);

      String jsonString = json.encode(response.data);

      ProductInfoModel model = productInfoModelFromJson(jsonString);

      return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future cartInit({required Map<String, dynamic> cartData}) async {
    try {
      Response response = await _apiClient.cartIniziate(cartData: cartData);

      log("Cart Resposne  :  ${response.data}");

      // String jsonString = json.encode(response.data);

      // ProductInfoModel model = prodcutInfoModelFromJson(jsonString);

      // return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartResModel> getActiveCart({required String customerId}) async {
    try {
      Response response =
          await _apiClient.getActiveCart(customerId: customerId);

      CartResModel model = CartResModel.fromJson(response.data);

      return model;

      // return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateCart(
      {required String cartId,
      required Map<String, dynamic> updatedCart}) async {
    try {
      Response response =
          await _apiClient.updateCart(cartId: cartId, cartData: updatedCart);

      var jsonString = json.encode(response.data);

      return jsonString;

      // return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckoutModel> getCheckout(
      {required String cartId,
      required String customerId,
      required String lat,
      required String lon}) async {
    try {
      Response response = await _apiClient.getCheckout(
          cartId: cartId, customerId: customerId, lat: lat, lon: lon);

      CheckoutModel model = CheckoutModel.fromJson(response.data);

      return model;

      // return model;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BannersModel>> getAllBanners() async {
    List<BannersModel> banners = await _apiClient.getAllBanners();
    return banners;
  }
}
