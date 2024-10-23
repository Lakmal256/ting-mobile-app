import 'package:dio/dio.dart';
import 'package:app/data/data.dart';

class SupportComplaintApi {
  Dio dio = AuthHandler.dio;

  // Get support and complain categories
  Future<dynamic> getSupportAndComplaintCategories() async {
    try {
      Response response = await dio.get(Api.urlGetSupportAndComplaint);
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  // Get active cases
  Future<dynamic> getActiveCases() async {
    try {
      Response response = await dio.get(Api.urlGetActiveCases);
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  // Get closed cases
  Future<dynamic> getClosedCases() async {
    try {
      Response response = await dio.get(Api.urlGetClosedCases);
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  // Get case by ID
  Future<dynamic> getCaseById(String id) async {
    try {
      Response response = await dio.get(Api.urlGetCaseById);
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  // Create new case
  Future<dynamic> createNewCase(
      String userId, Map<String, dynamic> caseData) async {
    try {
      Response response = await dio.post(
        Api.urlCreateCase,
        data: caseData,
        options: Options(headers: {'user-id': userId}),
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  // Update case
  Future<dynamic> updateCase(
      String userId, Map<String, dynamic> caseData) async {
    try {
      Response response = await dio.put(
        Api.urlUpdateCase,
        data: caseData,
        options: Options(headers: {'user-id': userId}),
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ResponseTimoutException();
    }
    throw RequestFailureException();
  }
}

class RequestFailureException implements Exception {}

class ResponseTimoutException implements Exception {}
