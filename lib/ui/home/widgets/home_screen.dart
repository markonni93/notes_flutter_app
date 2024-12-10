import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/ui/home/widgets/home_app_bar.dart';
import 'package:quick_notes/ui/home/widgets/home_drawer.dart';

import '../../core/action_button.dart';
import '../../core/expandable_fab_widget.dart';
import '../view_models/home_drawer_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _fabOpened = false;
  late HomeDrawerViewModel _drawerViewModel;

  @override
  void initState() {
    super.initState();
    _drawerViewModel = HomeDrawerViewModel(authRepository: context.read());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleFab(bool fabValue) {
    setState(() {
      _fabOpened = fabValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HomeDrawer(viewModel: _drawerViewModel),
      body: Stack(children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            const HomeAppBar(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: index.isOdd ? Colors.white : Colors.black12,
                    height: 100.0,
                    child: Center(
                      child: Text('$index',
                          textScaler: const TextScaler.linear(5.0)),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
        Positioned.fill(
            child: IgnorePointer(
          ignoring: !_fabOpened,
          child: AnimatedOpacity(
            opacity: _fabOpened ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Container(color: Colors.black54),
          ),
        ))
      ]),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.check_box),
          )
        ],
        onFabPressed: (bool value) => {_toggleFab(value)},
      ),
    );
  }
}
