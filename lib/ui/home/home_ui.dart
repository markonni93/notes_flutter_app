import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/ui/home/home_bloc.dart';

import '../../main.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                  child: Scaffold(
                      body: state.currentIndex == 0
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 840),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 250),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text("Something $index");
                                  }))
                          : ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 840),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 250),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text("Something else $index");
                                  })),
                      bottomNavigationBar: BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) => context
                              .read<HomeBloc>()
                              .add(TabClickedEvent(index: index)),
                          items: HomeBottomBarItem.values.map((navItem) {
                            return BottomNavigationBarItem(
                              icon: Icon(navItem.icon),
                              label: navItem.title,
                            );
                          }).toList())));
            }));
  }
}

enum HomeBottomBarItem {
  home(title: "Home", icon: Icons.home),
  settings(title: "Settings", icon: Icons.settings);

  const HomeBottomBarItem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
