import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/models/nav_item.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  //this logic had originally been done via setState()
  //in former MainScreen StatefulWidget. Now we emit a State from this
  //Cubit fuction instead
  void gotoSection(NavItem item) {
    emit(MainState(selected: item));
  }
}
