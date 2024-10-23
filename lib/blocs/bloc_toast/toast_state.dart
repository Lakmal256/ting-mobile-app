part of 'toast_bloc.dart';

class ToastState extends Equatable {
  const ToastState();

  @override
  List<Object> get props => [];
}

final class MakeToast extends ToastState {
  final String message;

  const MakeToast({required this.message});
  @override
  List<Object> get props => [message];
}
