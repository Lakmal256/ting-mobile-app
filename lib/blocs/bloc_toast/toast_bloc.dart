import 'dart:async';

import 'package:app/widgets/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'toast_event.dart';
part 'toast_state.dart';

class ToastBloc extends Bloc<ToastEvent, ToastState> {
  ToastBloc() : super(const ToastState()) {
    on<MakeToastEvent>(makeToastEvent);
  }

  FutureOr<void> makeToastEvent(
      MakeToastEvent event, Emitter<ToastState> emit) {
    if (event.inShell) {
      emit(MakeToast(message: event.message));
    } else {
      showToast(event);
    }
  }
}

void showToast(MakeToastEvent event) {
  showModalBottomSheet(
      context: event.context,
      isDismissible: false,
      builder: (BuildContext bc) {
        return CustomToastMessangerToast(message: event.message);
      });
}
