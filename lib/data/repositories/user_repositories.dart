import 'dart:io';

import 'package:app/data/data.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UserRepositories {
  Dio dio = AuthHandler.dio;
  Logger logger = Logger();

  // api call for reset password
  Future updateUserReop(
      {required String firstname,
      required String lastName,
      required String dob,
      required String email,
      required String mob,
      required String url,
      required String nic,
      required String identityId}) async {
    try {
      var payload = {
        "firstName": firstname,
        "lastName": lastName,
        "email": email,
        "mobile": mob,
        "dob": dob,
        "nic": nic,
        'gender': "",
        'profilePicture': url,
      };
      Response response =
          await dio.put("${Api.urlUpdateCustomer}/$identityId", data: payload);
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

  Future addNewAddressRepo(
      {required String id,
      required String address,
      required String city,
      required String district,
      required String province,
      required String postalCode,
      required String builingNo,
      required String builingName,
      required double latitude,
      required double longitude}) async {
    logger.d("addNewAddressRepo");
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    // Get user data
    final retrievedUser = await userPreferences.getUser();
    try {
      var payload = {
        "addressLine1": address,
        "addressLine2": "",
        "addressLine3": "",
        "bldName": builingName,
        "bldNo": builingNo,
        "city": city,
        "customerId": id,
        "district": district,
        "latitude": latitude,
        "longitude": longitude,
        "nickname": "",
        "postalCode": postalCode,
        "province": province,
        "roleId": "",
        "userId": retrievedUser!.loggedUser.identityId
      };

      Response response = await dio.post(Api.address, data: payload);
      if (response.statusCode == 201) {
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

  Future removeAddressRepo(
      {required String addressId,
      required String id,
      required String address,
      required String city,
      required String district,
      required String province,
      required String postalCode,
      required double latitude,
      required double longitude}) async {
    try {
      Response response = await dio.delete('${Api.address}/$addressId');
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
      return e.toString();
    }
  }

  Future updateAddress(
      {required String customerId,
      required String identityId,
      required String address,
      required String addressId,
      required String city,
      required String district,
      required String province,
      required String postalCode,
      required String builingNo,
      required String builingName,
      required double latitude,
      required double longitude,
      required bool isDefault}) async {
    var payload = {
      "addressLine1": address,
      "addressLine2": "",
      "addressLine3": "",
      "bldName": builingName,
      "bldNo": builingNo,
      "city": city,
      "district": district,
      "latitude": latitude,
      "longitude": longitude,
      "nickname": "",
      "postalCode": postalCode,
      "province": province,
      "roleId": "",
      "isDefault": isDefault,
      "id": addressId
    };

    try {
      Response response = await dio.put('${Api.address}/update',
          data: payload, options: Options(headers: {"User-Id": identityId}));
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

  Future updateImageFile({required File imageFile}) async {
    String fileName = imageFile.path.split('/').last;
    int chunkSize = 1024 * 1024; // 1 MB chunks (adjust as needed)
    List<int> fileBytes = await imageFile.readAsBytes();

    for (int offset = 0; offset < fileBytes.length; offset += chunkSize) {
      int end = (offset + chunkSize < fileBytes.length)
          ? offset + chunkSize
          : fileBytes.length;

      List<int> chunk = fileBytes.sublist(offset, end);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(chunk, filename: fileName),
      });

      try {
        var response = await dio.post(Api.urlUploadFile, data: formData);

        if (response.statusCode == 201) {
          return response.data['uploadedFileUrl'];
        } else {
          return response.statusCode;
        }
      } catch (e) {
        print("Error uploading chunk: $e");
      }
    }
  }
}
