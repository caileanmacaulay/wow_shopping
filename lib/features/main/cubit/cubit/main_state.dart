part of 'main_cubit.dart';

@immutable
class MainState {
  final NavItem selected;

  //Home is the default value
  MainState({this.selected = NavItem.home});
}
