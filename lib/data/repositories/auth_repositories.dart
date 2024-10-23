import 'dart:async';
import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositories {
  AuthRepositories() : _authClient = AuthClient();
  static const storage = FlutterSecureStorage();

  final AuthClient _authClient;
  Dio dio = Dio(BaseOptions(responseType: ResponseType.json));
  Logger logger = Logger();

  // headers
  final Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> userSignIn(
      {required String email, required String pass}) async {
    try {
      final response = await _authClient.userSignIn(email: email, pass: pass);

      UserLoginModel model = UserLoginModel.fromJson(response.data);

      final userPreferences =
          UserPreferencesRepository(await SharedPreferences.getInstance());

      userPreferences.saveUser(model);

      return model;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Future userSocialLoginRepo(
  //     {required String email,
  //     required String socialType,
  //     required String accessToken}) async {
  //   logger.d("userSocialLoginRepo");

  //   try {
  //     Response response = await dio.post(Api.urlSocialLogin,
  //         data: {"username": email, "socialLoginType": socialType},
  //         options: Options(headers: _headers));
  //     logger.i(
  //         "userSocialLoginRepo error || dio ${response.data} || ${response.statusCode} || ${response.statusMessage} ");
  //     if (response.statusCode == 200) {
  //       logger.i("social login success: code - ${response.data}");
  //       UserLoginModel loginModel = UserLoginModel.fromJson(response.data);
  //       return loginModel;
  //     } else {
  //       logger.e("social login error: code - ${response.statusCode}",
  //           error: response.statusMessage);

  //       return response.statusCode;
  //     }
  //   } on DioException catch (e) {
  //     logger.e(
  //         "userSocialLoginRepo error || dio ${e.error} || ${e.message} || ${e.response!.statusCode}",
  //         error: e.error);
  //     return e.response!.statusCode;
  //   } catch (e) {
  //     throw Exception('An unknown error occurred.');
  //   }
  // }

  Future<dynamic> userSocialLogin(
      {required String email,
      required String socialType,
      required String accessToken}) async {
    try {
      Response response = await _authClient.userSignInSocial(
          data: {"username": email, "socialLoginType": socialType});
      UserLoginModel loginModel = UserLoginModel.fromJson(response.data);
      return loginModel;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // apply api for customer signup
  Future<dynamic> userSignUpApply(
      {required String fName,
      required String lName,
      required String email,
      required String mobNo,
      required String nic,
      bool status = true,
      required String password,
      required bool isSocialUser,
      String? socialLogin,
      String? socialToken}) async {
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    userPreferences.saveData(UserPreferencesRepository.userPassKey, password);

    //header for social registration
    final Map<String, String> regHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'socialToken': '$socialToken'
    };

    try {
      Response response = await _authClient.userApplySignUp(data: {
        "firstName": fName,
        "lastName": lName,
        "email": email,
        "mobileNo": mobNo,
        "status": status,
        "password": password,
        "socialUser": isSocialUser,
        "socialLogin": socialLogin,
        'nic': nic,
        "type": "CUSTOMER"
      }, options: Options(headers: isSocialUser ? regHeaders : _headers));
      return ApplyResponseModel.fromJson(response.data);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // create customer api for customer signup
  Future createCustomerRepo({
    required String fName,
    required String lName,
    required String email,
    required String mobNo,
    required String dob,
    required String nic,
    required String cUID,
  }) async {
    try {
      await _authClient.userSignUp(
        data: {
          "userId": "",
          "roleId": "",
          "id": "",
          "gender": null,
          "nic": nic,
          "firstName": fName,
          "lastName": lName,
          "email": email,
          "mobile": mobNo,
          "dob": dob,
          "registerMode": "Direct",
          "customerUserId": cUID,
          "type": "CUSTOMER"
        },
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      log("Error Occuoured : $e");
      throw Exception('An unknown error occurred.');
    }
  }

  // api call for send otp to user mobile
  Future sendOtpRepo({required String username}) async {
    try {
      Response response = await dio.post("${Api.urlSendOtp}/$username");
      return response.statusCode;
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // api call for send otp to user mobile
  Future verifyOtpRepo({required String username, required String otp}) async {
    logger.d("verifyOtpRepo");

    try {
      Response response = await dio.post("${Api.urlVerifyOtp}/$username/$otp");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.statusCode;
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> userGetIamId({required String identity}) async {
    try {
      Response response = await _authClient.userGetIamId(identityId: identity);
      return IamUserModel.fromJson(response.data);
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> userVerify({required String id}) async {
    try {
      Response response = await _authClient.userVerify(userId: id);
      return response;
    } on AuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // api call for get verify customer from backend
  Future selfRegisterConfirmRepo({required String authCode}) async {
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    String? pass = await userPreferences
        .getStringData(UserPreferencesRepository.userPassKey);

    try {
      Response response = await dio.post(Api.urlSelfRegComplete,
          data: {"authorizationCode": authCode, "password": pass});

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return "error";
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // login api call for verify otp to user mobile
  Future sendLoginOtpRepo({required String mobile}) async {
    try {
      Response response = await dio.post("${Api.urlLoginSendOtp}/$mobile");
      return response.statusCode;
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // login api call for verify otp
  Future verifyLoginOtpRepo(
      {required String mobile, required String otp}) async {
    try {
      Response response =
          await dio.post("${Api.urlLoginVerifyOtp}/$mobile/$otp");
      if (response.statusCode == 200) {
        return response.data['result'].toString();
      } else {
        return response.statusCode;
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // api call for reset password
  Future resetPasswordReop(
      {required String authCode, required String password}) async {
    logger.d("resetPasswordReop");

    try {
      Response response = await dio.post("${Api.urlResetPassword}/$authCode",
          data: {"password": password, "authorizationCode": authCode});

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return 'error';
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // api call for reset password
  Future initUpdateMobileReop({required String mobile}) async {
    logger.d("initUpdateMobileReop");
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    // Get user data
    final retrievedUser = await userPreferences.getUser();

    try {
      Response response = await dio.put("${Api.urlInitChangeMobile}$mobile",
          options: Options(
              headers: {'user-iam-id': retrievedUser!.loggedUser.identityId}));

      if (response.statusCode == 202) {
        return response.statusCode;
      } else {
        return 'error';
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      return e.toString();
    }
  }

  // api call for reset password
  Future completeUpdateMobileReop(
      {required String mobile, required String authCode}) async {
    try {
      Response response = await dio.put(
        "${Api.urlChangeMobileComplete}$mobile?authorizationCode=$authCode",
        data: {'mobileNumber': mobile},
      );
      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return 'error';
      }
    } on DioException catch (e) {
      return e.response!.statusCode;
    } catch (e) {
      logger.e("Response error", error: e.toString());
      return e.toString();
    }
  }

  // api call for change password
  Future changePasswordReop(
      {required String password, required String newPassword}) async {
    logger.d("changePasswordReop");
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    // Get user data
    final retrievedUser = await userPreferences.getUser();

    print("Identity ID : ${retrievedUser!.loggedUser.identityId}");

    try {
      Response response = await dio.post(
          "${Api.urlChangePassword}${retrievedUser.loggedUser.identityId}/change-password?currentPassword=$password&newPassword=$newPassword",
          options: Options(
              headers: {"user-id": retrievedUser.loggedUser.identityId}));

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return 'error';
      }
    } on DioException catch (e) {
      logger.e(
          "Response error || dio ${e.error} || ${e.message} || ${e.response!.statusCode} || ${e.response}",
          error: e.error);
      return e.response!.statusCode;
    } catch (e) {
      logger.e("Response error", error: e.toString());
      return e.toString();
    }
  }

  Future<bool> isSignedIn() async {
    // Check if the user is signed in
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());
    final user = await userPreferences.getUser();
    return user != null;
  }
}
