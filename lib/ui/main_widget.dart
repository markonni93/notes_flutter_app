import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        child: state.currentIndex == 0
                            ? const HomeWidget()
                            : const SettingsWidget(),
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) => context
                              .read<MainWidgetBloc>()
                              .add(TabClickedEvent(index: index)),
                          items: MainBottomBarITem.values.map((navItem) {
                            return BottomNavigationBarItem(
                              icon: Icon(navItem.icon),
                              label: navItem.title,
                            );
                          }).toList())));
            }));
  }
}

enum MainBottomBarITem {
  home(title: "Home", icon: Icons.home),
  settings(title: "Settings", icon: Icons.settings);

  const MainBottomBarITem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
