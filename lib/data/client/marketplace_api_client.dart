import 'dart:convert';
import 'dart:io';

import 'package:app/data/data.dart';
import 'package:app/data/models/marketplace/banners_model.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RequestFailureException implements Exception {}

class ResponseEmptyException implements Exception {}

class ResponseTimoutException implements Exception {}

class MarketplaceApiClient {
  Dio dio = AuthHandler.dio;

  // get nearbuy vendors
  Future<List<VendorsModel>> fetchNearbuyVenders(
      {required String lat,
      required String lon,
      required String shopTypeId}) async {
    Response response = await dio.get(Api.nearbyShops, queryParameters: {
      'lat': lat,
      'lon': lon,
      'page': '1',
      'pageSize': '1000',
      'shopTypeId': shopTypeId
    });

    if (response.statusCode != 200) {
      throw RequestFailureException();
    }

    List<VendorsModel> list = vendorsModelFromJson(jsonEncode(response.data));

    return list;
  }

  // search products by name
  Future<List<VendorsModel>> searchsProductsByVendor(
      {required String searchText, required Address address}) async {
    Response response = await dio.get(Api.urlSearchShops, queryParameters: {
      'str': searchText,
      'lat': address.latitude,
      'lon': address.longitude,
      'page': '1',
      'pageSize': '100'
    });

    if (response.statusCode != 200) {
      throw RequestFailureException();
    }

    List<VendorsModel> productsByVendor =
        vendorsModelFromJson(jsonEncode(response.data));

    return productsByVendor;
  }

  // get products of shop
  Future<ProductsModel> getProductsByShop({required String shopId}) async {
    dio.interceptors
        .add(PrettyDioLogger(compact: true, error: true, responseBody: false));

    Response response = await dio.get(Api.urlGetProductsByShop + shopId,
        queryParameters: {'pageNumber': '1', 'pageSize': '100'});

    if (response.statusCode != 200) {
      throw RequestFailureException();
    }

    ProductsModel products = productsModelFromJson(jsonEncode(response.data));

    return products;
  }

  // // get all products by category
  // Future<List<CategorizedProductModel>> getCategorizedProducts() async {
  //   Response response = await dio.get(Api.urlGetCategorizedProduct);

  //   if (response.statusCode != 200) {
  //     throw RequestFailureException();
  //   }

  //   List<CategorizedProductModel> model =
  //       categorizedProductModelFromJson(jsonEncode(response.data));

  //   return model;
  // }

  Future<Response> getShopTypes() async {
    try {
      Response response = await dio.get(Api.shopTypes);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      }
      throw RequestFailureException;
    } catch (e) {
      throw Exception();
    }
  }

  Future<Response> getCategories({required String department}) async {
    try {
      Response response = await dio
          .get(Api.categories, queryParameters: {'department': department});
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      }
      throw RequestFailureException;
    } catch (e) {
      throw Exception();
    }
  }

  Future<Response> getVendorMenu({required String id}) async {
    try {
      Response response = await dio.get("${Api.vendor}/$id/menu");
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      }
      throw RequestFailureException;
    } catch (e) {
      throw Exception();
    }
  }

  Future<Response> getVendorProfile(
      {required String id, required String lat, required String lon}) async {
    try {
      Response response = await dio.get("${Api.vendor}/$id/profile",
          queryParameters: {"lat": lat, "lon": lon});
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      }
      throw RequestFailureException;
    } catch (e) {
      throw Exception();
    }
  }

  Future<Response> getProduct({required String id}) async {
    try {
      Response response = await dio.get("${Api.product}/$id");
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      }
      throw RequestFailureException;
    } catch (e) {
      throw Exception();
    }
  }

  Future<Response> cartIniziate(
      {required Map<String, dynamic> cartData}) async {
    try {
      Response response = await dio.post(
        Api.cart,
        data: cartData,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception(
            'An unknown error occurred while initializing the cart');
      }
      throw Exception();
    } catch (e) {
      // Return a default value or throw an exception
      throw Exception('Internal Server Error');
    }
  }

  Future<Response> getActiveCart({required String customerId}) async {
    try {
      Response response = await dio.get(
          "${Api.cart}/active/customer/$customerId",
          options: Options(
              responseType: ResponseType.json,
              contentType: ContentType.json.mimeType));
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      } else if (e.type == DioExceptionType.badResponse) {
        throw ResponseEmptyException();
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('An unknown error occurred');
      }
      throw Exception();
    } catch (e) {
      // Return a default value or throw an exception
      throw Exception('Internal Server Error');
    }
  }

  Future<Response> updateCart(
      {required Map<String, dynamic> cartData, required String cartId}) async {
    try {
      Response response = await dio.put("${Api.cart}/$cartId",
          data: cartData,
          options: Options(
              responseType: ResponseType.json,
              contentType: ContentType.json.mimeType));
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('An unknown error occurred');
      }
      throw Exception();
    } catch (e) {
      // Return a default value or throw an exception
      throw Exception('Internal Server Error');
    }
  }

  Future<Response> getCheckout(
      {required String cartId,
      required String customerId,
      required String lat,
      required String lon}) async {
    try {
      Response response = await dio.post(
          "${Api.cart}/$cartId/customer/$customerId/checkout",
          queryParameters: {"lat": lat, "lon": lon});
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseTimoutException();
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('An unknown error occurred');
      }
      throw Exception('Internal Server Error');
    } catch (e) {
      // Return a default value or throw an exception
      throw Exception('Internal Server Error');
    }
  }

  // get all banners
  Future<List<BannersModel>> getAllBanners() async {
    dio.interceptors
        .add(PrettyDioLogger(compact: true, error: true, responseBody: false));

    Response response = await dio.get(Api.banner);

    if (response.statusCode != 200) {
      throw RequestFailureException();
    }

    List<BannersModel> banners =
        bannersModelFromJson(jsonEncode(response.data));

    return banners;
  }
}
