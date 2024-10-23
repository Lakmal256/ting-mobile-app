import 'dart:async';
import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:dio/dio.dart';

class AuthClient {
  Dio dio = AuthHandler.dio;

  // user sign in
  Future<Response> userSignIn(
      {required String email, required String pass}) async {
    try {
      Response response = await dio.post(
        Api.urlLogin,
        data: {"username": email, "password": pass},
      );

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AuthException('Connection timed out.');
      }
      if (e.response?.statusCode == 401) {
        throw const AuthException('Invalid username or password.');
      } else if (e.response?.statusCode == 404) {
        throw const AuthException("Can't find user account");
      } else {
        throw const AuthException('Something went wrong!');
      }
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> getToken({required String token}) async {
    try {
      Response response =
          await dio.post(Api.refreshToken, data: {"refreshToken": token});

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AuthException('Connection timed out.');
      }
      throw TokenExpiredException('Session Expired!');
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> userSignInSocial(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await dio.post(Api.urlSocialLogin, data: data);

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AuthException('Connection timed out.');
      } else {
        throw const AuthException('Google signin\nfailed');
      }
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> userApplySignUp(
      {required Map<String, dynamic> data, required Options? options}) async {
    try {
      Response response =
          await dio.post(Api.urlApply, data: data, options: options);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AuthException('Connection timed out.');
      }

      if (e.response?.statusCode == 409) {
        throw const AuthException('Your account already\nexists');
      } else {
        throw const AuthException('Something went wrong!');
      }
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> userSignUp({required Map<String, dynamic> data}) async {
    try {
      Response response = await dio.post(
        Api.urlCreateCustomer,
        data: data,
      );
      if (response.statusCode == 201) {
        return response; // Success, return the response
      } else {
        // Handle other status codes here if needed
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.badResponse) {
        throw const AuthException('Connection timed out.');
      }

      if (e.response?.statusCode == 503) {
        throw const AuthException("Signup service unavailable");
      } else {
        throw const AuthException("Your account already exists");
      }
    } catch (e) {
      log("Error Occuoured : $e");
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> userGetIamId({required String identityId}) async {
    try {
      Response response = await dio.get(Api.getUserIamId + identityId);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.badResponse) {
        throw const AuthException('Connection timed out.');
      }

      if (e.response!.statusCode == 404) {
        throw const AuthException("User not found!");
      }

      throw const AuthException("Something went wrong!");
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<Response> userVerify({required String userId}) async {
    try {
      Response response = await dio.put('${Api.userVerify}/$userId/verify');

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.badResponse) {
        throw const AuthException('Connection timed out.');
      }
      if (e.response!.statusCode == 404) {
        throw const AuthException("User not found!");
      }

      throw const AuthException("Something went wrong!");
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }
}
