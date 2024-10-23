import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());
  UserLoginModel? userModel;

  void setView(ScreenView view) => emit(NavigationState(view: view));

  void getData() async {
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    // Get user data
    final retrievedUser = await userPreferences.getUser();

    userModel = retrievedUser;

    if (retrievedUser != null) {
      print('User ID: ${retrievedUser.loggedUser.id}');
      print('Username: ${retrievedUser.loggedUser.firstName}');
      print('Email: ${retrievedUser.loggedUser.email}');
    } else {
      log("No user data found!");
    }
  }
}
