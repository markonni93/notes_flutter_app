import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/model/note_list_ui_model.dart';

class ReorderableNoteList extends StatefulWidget {
  const ReorderableNoteList({super.key});

  @override
  State<ReorderableNoteList> createState() => _ReorderableNoteListState();
}

class _ReorderableNoteListState extends State<ReorderableNoteList> {
  final List<NoteListUiModel> _listItem = [];
  final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return AnimatedList(
      key: _animatedListKey,
      initialItemCount: _listItem.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return SizeTransition(
            sizeFactor: animation,
            child: myListItem(
                _listItem[index], index, oddItemColor, evenItemColor));
      },
    );
  }

  Widget myListItem(NoteListUiModel item, int index, Color oddItemColor,
      Color evenItemColor) {
    return ListTile(
        //key: Key(_listItem[index].id),
        leading: const Icon(Icons.drag_handle),
        trailing: IconButton(
            onPressed: () =>
                _removeItemAtIndex(index, oddItemColor, evenItemColor),
            icon: const Icon(Icons.clear)),
        title: TextField(
          maxLines: 1,
          autofocus: true,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          onSubmitted: (value) => _addNoteToListAndCreateNewItem(value, index),
        ));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _listItem.add(
          NoteListUiModel(id: const Uuid().v1(), text: "", isChecked: false));
      _animatedListKey.currentState?.insertItem(0);
    });
  }

  _removeItemAtIndex(int index, Color oddItemColor, Color evenItemColor) {
    setState(() {
      if (index > 0) {
        var removedItem = _listItem.removeAt(index);
        _animatedListKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: myListItem(
                    removedItem, index, oddItemColor, evenItemColor)));
      }
    });
  }

  _addNoteToListAndCreateNewItem(String text, int index) {
    setState(() {
      _listItem[index] = _listItem[index].copyWith(text: text);
      _listItem.insert(index++,
          NoteListUiModel(id: const Uuid().v1(), text: "", isChecked: false));
      _animatedListKey.currentState?.insertItem(index++);
    });
  }
}
