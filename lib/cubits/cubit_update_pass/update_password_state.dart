part of 'update_password_cubit.dart';

sealed class UpdatePasswordState extends Equatable {
  const UpdatePasswordState();

  @override
  List<Object> get props => [];
}

final class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordLoadingState extends UpdatePasswordState {
  @override
  List<Object> get props => [];
}

class UpdatePasswordErrorState extends UpdatePasswordState {
  final String message;

  const UpdatePasswordErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class UpdatePasswordSuccessState extends UpdatePasswordState {
  @override
  List<Object> get props => [];
}
