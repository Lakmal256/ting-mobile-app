part of 'tab_view_cubit.dart';

class TabViewState extends Equatable {
  final int position;

  const TabViewState({this.position = 1});

  @override
  List<Object> get props => [position];
}

class TabViewDataState extends Equatable {
  final UserLoginModel? userModel;

  const TabViewDataState({required this.userModel});

  @override
  List<Object> get props => [userModel!];
}
