import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_bloc.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoteList();
  }
}

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case HomeStatus.success:
            if (state.notes.isEmpty) {
              return const Center(child: Text('no notes'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.notes.length
                    ? const Center(
                        child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(state.notes[index].title));
              },
              itemCount: state.hasReachedMax
                  ? state.notes.length
                  : state.notes.length + 1,
              controller: _scrollController,
            );
          case HomeStatus.failure:
            return const Center(child: Text('failed to fetch notes'));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HomeBloc>().add(NotesFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}