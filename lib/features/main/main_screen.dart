import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/cubit/cubit/main_cubit.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: MainView(),
    );
  }
  //Using a Page-View pattern we extrated top level of widget Build as
  //MainView() and wrapped it in BlocProvider to supply the Cubit via
  //context, ie make it available down the element tree (to the next new buildContext)
}

@immutable
class MainView extends StatelessWidget {
  const MainView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //access the State of the Cubit by subscribing to it
    //via context. We watch it's value.
    //final mainState = context.watch<MainCubit>().state;

    //listening only the part of the State we need to rebuild with
    final selected = context.select(
      (MainCubit cubit) => cubit.state.selected,
    );

    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              //context.read gives us access to Cubit instance
              //to call it's method(s) or with Bloc emit an Event
              onNavItemPressed: context.read<MainCubit>().gotoSection,
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }
}
