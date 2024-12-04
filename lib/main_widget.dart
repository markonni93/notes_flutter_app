import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/main_bloc.dart';
import 'package:flutter_notes/settings/settings_widget.dart';

import 'create/create_note_widget.dart';
import 'home/home_widget.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainWidgetBloc(),
        child: BlocBuilder<MainWidgetBloc, MainWidgetState>(
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
                  floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => Navigator.of(context)
                          .push(_constructCreateScreenRoute())),
                  floatingActionButtonAnimator:
                      FloatingActionButtonAnimator.scaling,
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

Route _constructCreateScreenRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const CreateScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start position (bottom of screen)
      const end = Offset.zero; // End position (current screen)
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
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
