import 'package:app/data/data.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSigninSevrice extends ChangeNotifier {
  Logger log = Logger();
  Dio dio = Dio();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;

  AuthCredential? _credential;
  AuthCredential? get credential => _credential;

  PeopleModel? _peopleModel;
  PeopleModel? get peopleModel => _peopleModel;

  Future<UserDataModel?> googleGetUserData({required bool isLogin}) async {
    log.d("Process Google Service");

    _googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await _googleSignInAccount?.authentication;
    _credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken, idToken: googleAuth.idToken);

    log.d("Process Google Service 2");

    if (isLogin) {
      UserDataModel dataModel = UserDataModel(
          firstName: '',
          lastName: '',
          email: googleSignInAccount!.email,
          credentials: _credential!);
      return dataModel;
    } else {
      log.d("Sign Up");
      await peopleGoogleAPI(accessToken: googleAuth.accessToken!);
      UserDataModel dataModel = UserDataModel(
          firstName: _peopleModel!.names.first.givenName,
          lastName: _peopleModel!.names.first.familyName,
          email: googleSignInAccount!.email,
          credentials: _credential!);
      return dataModel;
    }
  }

  Future<void> googleSignWithCredentials(
      {required AuthCredential? credentials}) async {
    print("googleSignWithCredentials => $credentials");
    try {
      await FirebaseAuth.instance.signInWithCredential(credentials!);
    } catch (e) {
      log.e("googleSignWithCredentials error");
    }
  }

  Future peopleGoogleAPI({required String accessToken}) async {
    log.d("peopleGoogleAPI");
    Response response = await dio.get(
        "https://people.googleapis.com/v1/people/me?personFields=names",
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }));

    log.e("response : ${response.statusCode}");
    log.e("response : ${response.statusMessage}");

    if (response.statusCode == 200) {
      _peopleModel = PeopleModel.fromJson(response.data);
    } else {
      _peopleModel = PeopleModel(resourceName: '', etag: '', names: []);
    }
  }
}
