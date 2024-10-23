part of 'toast_bloc.dart';

sealed class ToastEvent extends Equatable {
  const ToastEvent();

  @override
  List<Object> get props => [];
}

class MakeToastEvent extends ToastEvent {
  final String message;
  final BuildContext context;
  final bool inShell;

  const MakeToastEvent(
      {required this.message, required this.context, this.inShell = true});

  @override
  List<Object> get props => [message];
}
