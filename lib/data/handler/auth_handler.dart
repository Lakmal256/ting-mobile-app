import 'dart:developer';
import 'dart:io';
import 'package:app/data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum TokenType { accessToken, refreshToken }

class AuthHandler {
  static const storage = FlutterSecureStorage();
  static Dio dio = Dio();

  AuthInterceptor inspector = AuthInterceptor(storage);
  final AuthClient _authClient = AuthClient();

  AuthHandler() {
    dio.options.contentType = ContentType.json.mimeType;
    dio.interceptors.addAll([
      inspector,
      PrettyDioLogger(
          requestHeader: true, requestBody: true, responseBody: true)
    ]);
  }

  Future<dynamic> userSignIn(
      {required String email, required String pass}) async {
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());
    await storage.deleteAll();
    await userPreferences.removeUser();

    try {
      final response = await _authClient.userSignIn(email: email, pass: pass);

      UserLoginModel model = UserLoginModel.fromJson(response.data);

      _storeToken(TokenType.accessToken, model.accessToken);
      _storeToken(TokenType.refreshToken, model.refreshToken);

      return model;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<dynamic> refreshToken({required String token}) async {
    try {
      final response = await _authClient.getToken(token: token);
      UserLoginModel user = UserLoginModel.fromJson(response.data);

      _storeToken(TokenType.accessToken, user.accessToken);
      _storeToken(TokenType.refreshToken, user.refreshToken);
    } on AuthException catch (e) {
      if (e is TokenExpiredException) {
        log("Session expired");
        await signOut();
        // Navigate to login screen using GoRouter
        // context.go('/login');
      } else {
        log(e.message);
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<dynamic> signOut() async {
    await storage.deleteAll();
    await UserPreferencesRepository(await SharedPreferences.getInstance())
        .removeUser();
  }

  Future<void> _storeToken(TokenType type, String token) async {
    await storage.write(key: type.name, value: token);
  }
}

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor(this.storage);
  final FlutterSecureStorage storage;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == Api.refreshToken ||
        options.path == Api.urlLogin ||
        options.path == Api.urlApply ||
        options.path == Api.urlCreateCustomer ||
        options.path == Api.urlSelfRegComplete ||
        options.path == Api.urlVerifyOtp ||
        options.path == Api.urlSocialLogin ||
        options.path.contains(Api.getUserIamId) ||
        options.path == 'people.googleapis.com') {
      handler.next(options);
      return;
    }

    final accessToken = await storage.read(key: TokenType.accessToken.name);

    UserLoginModel? user =
        await UserPreferencesRepository(await SharedPreferences.getInstance())
            .getUser();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $accessToken";
      options.headers['User-Id'] = user!.loggedUser.identityId;

      handler.next(options);
      return;
    } else {
      handler.reject(DioException.receiveTimeout(
          timeout: 10.seconds, requestOptions: RequestOptions()));
    }
  }

  @override
  void onError(DioException? err, ErrorInterceptorHandler handler) async {
    if (err?.response?.statusCode == 401) {
      String? refreshToken =
          await storage.read(key: TokenType.refreshToken.name);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          await AuthHandler().refreshToken(token: refreshToken);
          return await _retry(err, handler);
        } on AuthException {
          log("AuthException");
        }
      } else {
        await signOut();
        // Navigate to login screen using GoRouter
        // context.go('/login');
      }
    }
    return super.onError(err!, handler);
  }

  Future<void> _retry(
      DioException? err, ErrorInterceptorHandler handler) async {
    final accessToken = await storage.read(key: TokenType.accessToken.name);

    final requsetOptions = err?.requestOptions;
    requsetOptions?.headers['Authorization'] = "Bearer $accessToken";

    final options = Options(
        method: requsetOptions?.method, headers: requsetOptions?.headers);

    final dioRetry = Dio(BaseOptions(baseUrl: requsetOptions!.baseUrl));

    final retryResponse = await dioRetry.request(requsetOptions.path,
        data: requsetOptions.data,
        queryParameters: requsetOptions.queryParameters,
        options: options);

    return handler.resolve(retryResponse);
  }

  signOut() {
    storage.deleteAll();
    Logger logger = Logger();
    logger.e("signOut");
    // Navigate to login screen using GoRouter
    // context.go('/login');
  }
}
