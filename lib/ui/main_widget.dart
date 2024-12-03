import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/main.dart';
import 'package:flutter_notes/ui/home/home_widget.dart';
import 'package:flutter_notes/ui/main_bloc.dart';
import 'package:flutter_notes/ui/settings/settings_widget.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainWidgetBloc(),
        child: BlocConsumer<MainWidgetBloc, MainWidgetState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                  child: Scaffold(
                      body: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _getWidgetForIndex(state.currentIndex),
                      ),
                      bottomNavigationBar: NavigationBar(
                          selectedIndex: state.currentIndex,
                          onDestinationSelected: (index) => context
                              .read<MainWidgetBloc>()
                              .add(TabClickedEvent(index: index)),
                          destinations: MainBottomBarItem.values
                              .map((e) => NavigationDestination(
                                    icon: Icon(e.icon),
                                    label: e.title,
                                  ))
                              .toList())));
            }));
  }
}

Widget _getWidgetForIndex(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return const HomeWidget();
    case 1:
      return const SettingsWidget();
    default:
      throw Exception("something went wrong");
  }
}

enum MainBottomBarItem {
  home(title: "Home", icon: Icons.home),
  settings(title: "Settings", icon: Icons.settings);

  const MainBottomBarItem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
