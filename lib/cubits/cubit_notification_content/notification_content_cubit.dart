// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_content_state.dart';

enum NavItem { home, liquor, search, cart, profile }

class NotifiContentModel {
  final String item;
  final String content;

  NotifiContentModel({required this.item, required this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item,
      'content': content,
    };
  }

  factory NotifiContentModel.fromMap(Map<String, dynamic> map) {
    return NotifiContentModel(
      item: map['item'],
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotifiContentModel.fromJson(String source) =>
      NotifiContentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class NotificationContentCubit extends Cubit<NotificationContentState> {
  NotificationContentCubit() : super(NotificationContentInitial());

  List<NotifiContentModel> contentList = [];

  void updateContent(
      {required String targetItem, required String? content}) async {
    log("Update Notification Content Called");
    emit(const NotificationContentLoading());
    var containIndex =
        contentList.indexWhere((element) => element.item == targetItem);
    log("$containIndex");
    if (containIndex == -1) {
      contentList.add(NotifiContentModel(item: targetItem, content: content!));
    } else {
      contentList.removeAt(containIndex);
      contentList.add(NotifiContentModel(item: targetItem, content: content!));
    }
    log("Update Notification Content Done");
    emit(UpdateNotificationContent(contentList: contentList));
  }

  void clearContent() {
    contentList.clear();
    emit(UpdateNotificationContent(contentList: contentList));
  }
}
