import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/ui/core/list_note_item_widget.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';
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
    widget.viewModel.fetchNotes();
    widget.viewModel.addListener(_showSnackbar);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.viewModel.disposeNoteStream();
    widget.viewModel.removeListener(_showSnackbar);
    super.dispose();
  }

  void _showSnackbar() {
    if (widget.viewModel.showSnackbar) {
      final snackBar = SnackBar(
        content: Text(widget.viewModel.snackbarMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _toggleFab(bool fabValue) {
    setState(() {
      _fabOpened = fabValue;
    });
  }

  void _onScroll() {
    if (_isBottom) {
      widget.viewModel.fetchNotes();
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
        StreamBuilder<List<NoteUiModel>>(
            stream: widget.viewModel.notesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final data = snapshot.requireData;
                return CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    const HomeAppBar(),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250.0, childAspectRatio: 1.4),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final item = data[index];
                          switch (item) {
                            case TextNoteUiModel():
                              return NoteCard(
                                model: item,
                                index: index,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              );
                            case ListNoteUiModel():
                              return ListNoteCard(
                                  model: item,
                                  index: index,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer);
                          }
                        },
                        childCount: snapshot.data?.length,
                      ),
                    )
                  ],
                );
              }
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
