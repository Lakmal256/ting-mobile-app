part of 'navigation_cubit.dart';

enum ScreenView { home, liquor ,search, cart, profile }

class NavigationState extends Equatable {
  final ScreenView view;

  const NavigationState({this.view = ScreenView.home});

  @override
  List<Object> get props => [view];
}
