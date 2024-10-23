// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:app/locator.dart';

class Api {
  Api._();

  static String BASE_URL = locate<LocatorConfig>().baseUrl;
  static String BASE_MARKETPLACE = locate<LocatorConfig>().baseUrlMarketplace;
  static const String _userInternal = "identity/user";
  static const String _userExternal = "identity/user/external";

  /// login
  static String urlLogin = "$BASE_URL/$_userInternal/login";
  static String urlSocialLogin = "$BASE_URL/$_userInternal/social/login";

  ///refresh token
  static String refreshToken = "$BASE_URL/identity/user/login/refresh";

  /// signup
  static String urlApply = "$BASE_URL/$_userExternal/register/apply";
  static String urlCreateCustomer = "$BASE_MARKETPLACE/me/create";
  static String urlSelfRegComplete =
      "$BASE_URL/$_userExternal/register/complete";

  /// otp signup
  /// static  String urlSendOtp = "$BASE_URL/utility/sendotp";
  static String urlSendOtp = "$BASE_URL/utility/login/sendotp";
  static String urlVerifyOtp = "$BASE_URL/utility/verifyotp";

  /// otp login
  static String urlLoginSendOtp = "$BASE_URL/utility/login/sendotp";
  static String urlLoginVerifyOtp = "$BASE_URL/utility/login/verifyotp";

  // initialize update user mobile number
  static String urlInitChangeMobile = "$BASE_URL/identity/user/mobile/init/";
  // complete update user mobile number
  static String urlChangeMobileComplete =
      "$BASE_URL/identity/user/mobile/complete/";

  /// complete update user mobile number
  static String urlChangePassword = "$BASE_URL/identity/user/";

  /// reset password
  static String urlResetPassword = "$BASE_URL/identity/user/resetpassword";

  /// customer
  static String getUserIamId = "$BASE_MARKETPLACE/me/identity/";
  static String userVerify = "$BASE_MARKETPLACE/me/identity";
  static String urlUpdateCustomer = "$BASE_MARKETPLACE/me/identity";

  /// address
  static String address = "$BASE_MARKETPLACE/me/address";

  /// profile image
  static String urlUploadFile = '$BASE_MARKETPLACE/common/uploadfile';

  /// marketplace home
  static String shopTypes = '$BASE_MARKETPLACE/ecom/shops/types';
  static String categories = '$BASE_MARKETPLACE/ecom/categories';

  /// vendors
  static String nearbyShops = '$BASE_MARKETPLACE/ecom/shops/nearby';
  static String urlSearchNearbyVendors =
      '${BASE_MARKETPLACE}ecom/vendor/search';
  static String urlSearchProducts = '$BASE_MARKETPLACE/ecom/product/search';
  static String urlSearchShops = '$BASE_MARKETPLACE/ecom/shops/search';
  static String urlGetProductsByShop =
      '${BASE_MARKETPLACE}ecom/product/search/vendorshop/';
  static String urlGetCategorizedProduct =
      '${BASE_MARKETPLACE}product/category';

  static String vendor = '$BASE_MARKETPLACE/ecom/shops';

  /// products
  static String product = '$BASE_MARKETPLACE/ecom/products';

  /// cart
  static String cart = '$BASE_MARKETPLACE/cart';

  // Marketplace Support & Complaint API
  static String urlGetSupportAndComplaint =
      '$BASE_MARKETPLACE/support/case/categories';
  static String urlGetActiveCases = '$BASE_MARKETPLACE/support/active';
  static String urlGetClosedCases = '$BASE_MARKETPLACE/support/closed';
  static String urlGetCaseById = '$BASE_MARKETPLACE/support/case/';
  static String urlCreateCase = '$BASE_MARKETPLACE/support/new/create';
  static String urlUpdateCase = '$BASE_MARKETPLACE/support/update';

  /// banner
  static String banner = '$BASE_MARKETPLACE/ecom/banner/all';
}
