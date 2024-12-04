import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/ui/home/home_bloc.dart';

import '../../data/notes_repository.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => HomeBloc(
            repository: RepositoryProvider.of<NotesRepository>(context))
          ..add(NotesFetched()),
        child: const NoteList());
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
    return BlocBuilder<HomeBloc, NoteState>(
      builder: (context, state) {
        switch (state.status) {
          case NoteStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case NoteStatus.success:
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
                    : Padding(padding: const EdgeInsets.all(32.0), child: Text(state.notes[index].title));
              },
              itemCount: state.hasReachedMax
                  ? state.notes.length
                  : state.notes.length + 1,
              controller: _scrollController,
            );
          case NoteStatus.failure:
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
