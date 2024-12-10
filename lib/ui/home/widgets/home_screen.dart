import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';
import 'package:quick_notes/ui/core/note_item_widget.dart';
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
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return NoteCard(
                    model: NoteUiModel(
                        id: 1,
                        note: "My note $index",
                        title: "Title $index",
                        createdAt: "createdAt"),
                    index: index,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  );
                },
                childCount: 40,
              ),
            )
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
