import 'package:app/data/repositories/auth_repositories.dart';
import 'package:app/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordInitial());

  void updateOnPressed(
      {required String password,
      required String conpPassword,
      required String token}) async {
    emit(UpdatePasswordLoadingState());

    // Validate password
    var passwordValid =
        password.isEmpty ? null : ValidationService.isValidPassword(password);

// Validate confirm password
    var confirmPassValid = conpPassword.isEmpty
        ? null
        : ValidationService.isValidConfirmPassword(password, conpPassword);

    if (passwordValid != 'valid') {
      emit(UpdatePasswordErrorState(message: passwordValid!));
    } else if (confirmPassValid != 'valid') {
      emit(UpdatePasswordErrorState(message: confirmPassValid!));
    } else {
      var response = await AuthRepositories()
          .resetPasswordReop(authCode: token, password: password);
      if (response == 200) {
        // password update success
        emit(UpdatePasswordSuccessState());
      } else {
        emit(const UpdatePasswordErrorState(message: "Somthing went wrong!"));
      }
    }
  }
}
