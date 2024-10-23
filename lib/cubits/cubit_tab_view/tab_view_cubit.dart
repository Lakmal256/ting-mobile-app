import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_view_state.dart';

class TabViewCubit extends Cubit<TabViewState> {
  TabViewCubit() : super(const TabViewState());

  void setTabPosition({required int position}) =>
      emit(TabViewState(position: position));

  void getData() async {
    final userPreferences =
        UserPreferencesRepository(await SharedPreferences.getInstance());

    // Get user data
    final retrievedUser = await userPreferences.getUser();

    if (retrievedUser != null) {
      print('User ID: ${retrievedUser.loggedUser.id}');
      print('Username: ${retrievedUser.loggedUser.firstName}');
      print('Email: ${retrievedUser.loggedUser.email}');

    } else {
      log("No user data found!");
    }
  }
}
