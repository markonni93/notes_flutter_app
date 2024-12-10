import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/ui/core/note_item_widget.dart';
import 'package:quick_notes/ui/home/view_models/home_screen_viewmodel.dart';
import 'package:quick_notes/ui/home/widgets/home_app_bar.dart';
import 'package:quick_notes/ui/home/widgets/home_drawer.dart';

import '../../core/expandable_fab_widget.dart';
import '../view_models/home_drawer_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeScreenViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _fabOpened = false;
  late HomeDrawerViewModel _drawerViewModel;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _drawerViewModel = HomeDrawerViewModel(authRepository: context.read());
    _scrollController.addListener(_onScroll);
    widget.viewModel.fetchNotes.addListener(_onResult);
    widget.viewModel.fetchNotes.execute(0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.viewModel.fetchNotes.removeListener(_onResult);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.fetchNotes.removeListener(_onResult);
    widget.viewModel.fetchNotes.addListener(_onResult);
  }

  void _toggleFab(bool fabValue) {
    setState(() {
      _fabOpened = fabValue;
    });
  }

  void _onScroll() {
    if (_isBottom) {
      widget.viewModel.fetchNotes.execute(widget.viewModel.items.length);
    }
  }

  void _onResult() {
    if (widget.viewModel.fetchNotes.completed) {
      widget.viewModel.fetchNotes.clearResult();
    }
    if (widget.viewModel.fetchNotes.error) {
      widget.viewModel.fetchNotes.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error something went wrong"),
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HomeDrawer(viewModel: _drawerViewModel),
      body: Stack(children: [
        ListenableBuilder(
            listenable: widget.viewModel.fetchNotes,
            builder: (context, child) {
              return CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  const HomeAppBar(),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250.0, childAspectRatio: 1.5),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return NoteCard(
                          model: widget.viewModel.items[index],
                          index: index,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        );
                      },
                      childCount: widget.viewModel.items.length,
                    ),
                  )
                ],
              );
            }),
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
        onFabPressed: (bool value) => {_toggleFab(value)},
      ),
    );
  }
}
