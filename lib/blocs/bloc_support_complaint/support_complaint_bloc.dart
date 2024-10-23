import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'support_complaint_event.dart';
part 'support_complaint_state.dart';

class SupportComplaintBloc extends Bloc<SupportComplaintEvent, SupportComplaintState> {
  SupportComplaintBloc() : super(SupportComplaintInitial()) {
    on<SupportComplaintEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
