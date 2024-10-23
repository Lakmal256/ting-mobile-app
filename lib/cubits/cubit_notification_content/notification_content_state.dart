part of 'notification_content_cubit.dart';

sealed class NotificationContentState extends Equatable {
  const NotificationContentState();

  @override
  List<Object> get props => [];
}

final class NotificationContentInitial extends NotificationContentState {}

final class UpdateNotificationContent extends NotificationContentState {
  final List<NotifiContentModel> contentList;

  const UpdateNotificationContent({required this.contentList});
  @override
  List<Object> get props => [contentList];
}

final class NotificationContentLoading extends NotificationContentState {
  const NotificationContentLoading();

  @override
  List<Object> get props => [];
}
