part of 'support_complaint_bloc.dart';

sealed class SupportComplaintState extends Equatable {
  const SupportComplaintState();
  
  @override
  List<Object> get props => [];
}

final class SupportComplaintInitial extends SupportComplaintState {}
